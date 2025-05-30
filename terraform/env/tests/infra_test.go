package test

import (
    "context"
    "testing"

    "cloud.google.com/go/compute/metadata"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
    "google.golang.org/api/iterator"
    "google.golang.org/api/option"
    "google.golang.org/api/compute/v1"
)

func TestGCPInfrastructure(t *testing.T) {
    t.Parallel()

    terraformOptions := &terraform.Options{
        // Path to your Terraform code
        TerraformDir: "../dev",

        // Variables to pass to Terraform
        Vars: map[string]interface{}{
            "region": "asia-south1-a",
            "project": "microservices-test-ps",
        },

		// Initialize with the 'test' workspace
        EnvVars: map[string]string{
            "TF_WORKSPACE": "test",
        },
    }

    // Initialize and apply Terraform
    defer terraform.Destroy(t, terraformOptions)
    terraform.InitAndApply(t, terraformOptions)

    // Verify the GCP region
    outputRegion := terraform.Output(t, terraformOptions, "region")
    assert.Equal(t, "us-central1", outputRegion)

    // Verify the GCP VPC Network
    outputVPC := terraform.Output(t, terraformOptions, "network_name")
    assert.NotEmpty(t, outputVPC)

    // Verify the GCP VPC Configuration using GCP API Client
    ctx := context.Background()
    computeService, err := compute.NewService(ctx, option.WithProjectID("microservices-test-ps"))
    assert.NoError(t, err)

    // List VPCs to find our specific VPC
    networksService := compute.NewNetworksService(computeService)
    req := networksService.List("microservices-test-ps")
    var vpcExists bool
    for {
        resp, err := req.Do()
        if err != nil {
            t.Fatalf("Could not list VPCs: %v", err)
        }
        for _, vpc := range resp.Items {
            if vpc.Name == outputVPC {
                vpcExists = true
                assert.Equal(t, "10.0.0.0/16", vpc.IPv4Range) // Example CIDR assertion
                break
            }
        }
        if len(resp.Items) == 0 {
            break
        }
    }
    assert.True(t, vpcExists, "VPC does not exist")

    // Additional optional checks can be added here, like checking specific instances, instances' labels, etc.
}