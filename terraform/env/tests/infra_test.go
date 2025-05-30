package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestVerifyRegion(t *testing.T) {
	t.Parallel()

	// Define the Terraform options
	terraformOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: "../dev",  // Update this path

		// Variables to pass to Terraform
		Vars: map[string]interface{}{
			"region": "asia-south1",  // Update to your desired target region
		},
	}

	// Clean up resources with "terraform destroy" at the end of the test
	defer terraform.Destroy(t, terraformOptions)

	// Run "terraform init" and "terraform apply" and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run "terraform output" to get the value of the output for region
	outputRegion := terraform.Output(t, terraformOptions, "region")

	// Verify we are setting the region correctly
	assert.Equal(t, "asia-south1", outputRegion)
}