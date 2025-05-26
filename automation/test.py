"""
1. Get the nodes IP
2. Get master IP or CIDR range
3. Clone Github repo and add the terraform code for FW rule
4. Trigger terraform pipeline to deploy the changes
"""
from google.cloud import container_v1
from kubernetes import client, config
import sys

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