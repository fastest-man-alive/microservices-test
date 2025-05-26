"""
1. Get the nodes IP
2. Get master IP or CIDR range
3. Clone Github repo and add the terraform code for FW rule
4. Trigger terraform pipeline to deploy the changes
"""
from google.cloud import container_v1
from kubernetes import client, config
import sys
import re
import os

# Load kube config (works locally with `gcloud container clusters get-credentials`)
config.load_kube_config()

# Initialize Kubernetes API
v1 = client.CoreV1Api()

# Fetch all nodes
nodes = v1.list_node()

print("GKE Node IP Addresses:")
for node in nodes.items:
    node_name = node.metadata.name
    internal_ip = None
    external_ip = None

    for address in node.status.addresses:
        if address.type == "InternalIP":
            internal_ip = address.address
        elif address.type == "ExternalIP":
            external_ip = address.address

    print(f"Node: {node_name}")
    print(f"  Internal IP: {internal_ip}")
    print(f"  External IP: {external_ip}")

client = container_v1.ClusterManagerClient()

project_id = sys.argv[1]
region = sys.argv[3]
cluster_name = sys.argv[2]
cluster_path = f"projects/{project_id}/locations/{region}/clusters/{cluster_name}"

cluster = client.get_cluster(name=cluster_path)

print("GKE Control Plane Endpoint:", cluster.endpoint)

#Dunamically insert firewall to terraform
def insert_firewall_rule_unique(filepath, endpoint, network_name, rule_name):
    with open(filepath, "r") as f:
        lines = f.readlines()

    in_target_module = False
    firewall_rules_start = None
    rule_exists = False
    bracket_level = 0

    for i, line in enumerate(lines):
        stripped = line.strip()

        # Step 1: Check for correct module
        if stripped.startswith("module "):
            in_target_module = False  # reset
        if 'network_name' in stripped and f'"{network_name}"' in stripped:
            in_target_module = True

        # Step 2: Locate firewall_rules block
        if in_target_module and 'firewall_rules' in stripped and '=' in stripped and '[' in stripped:
            firewall_rules_start = i + 1  # insert after this line
            bracket_level = line.count('[') - line.count(']')
            continue

        # Step 3: Look for existing rule name inside firewall_rules block
        if firewall_rules_start and i > firewall_rules_start:
            bracket_level += line.count('[') - line.count(']')
            if f'name = "{rule_name}"' in line:
                rule_exists = True
            if bracket_level == 0:
                break

    if rule_exists:
        print(f"Rule with name '{rule_name}' already exists. Skipping insert.")
        return

    if firewall_rules_start is None:
        print("Did not find target module or firewall_rules block.")
        return

    # Step 4: Prepare rule block
    new_rule = f'''
        {{
            name = "{rule_name}"
            direction = "INGRESS"
            source_ranges = ["{endpoint}"]
            allow = [
                {{
                    protocol = "tcp"
                    ports = ["80", "443"]
                }}
            ]
        }},
    '''
    new_rule_lines = [line + "\n" for line in new_rule.strip().splitlines()]
    
    # Step 5: Insert rule
    updated_lines = lines[:firewall_rules_start] + new_rule_lines + lines[firewall_rules_start:]

    with open(filepath, "w") as f:
        f.writelines(updated_lines)
        print(updated_lines)

    print(f"Rule '{rule_name}' inserted successfully.")
    # After inserting the rule and writing the file...




# ✅ Usage example:
os.chdir('..')
print("Current directory:", os.getcwd())
os.chdir('terraform\env\dev')
insert_firewall_rule_unique(
    filepath="vpc.tf",
    endpoint=cluster.endpoint,
    network_name="kubernetes-vpc",
    rule_name="allow-custom-ip"
)


