#!/bin/bash

# Configuration file path
CONFIG_FILE="config.tfvars.json"

AWS_PROFILE=$(jq -r '.aws_profile' "$CONFIG_FILE")
AWS_REGION=$(jq -r '.aws_region' "$CONFIG_FILE")
AWS_ACCOUNT_ID=$(jq -r '.aws_account_id' "$CONFIG_FILE")
ECR_REPOSITORY=$(jq -r '.project_name' "$CONFIG_FILE")  
IMAGE_TAG=$(jq -r '.image_tag' "$CONFIG_FILE")  

ECR_REPOSITORY_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY}"

# Log in to ECR
echo "Logging in to Amazon ECR using profile ${AWS_PROFILE}..."
aws ecr get-login-password --region "${AWS_REGION}" --profile "${AWS_PROFILE}" | docker login --username AWS --password-stdin "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

# Check if repository exists, create if it doesn't
echo "Checking if repository exists..."
if ! aws ecr describe-repositories --repository-names "${ECR_REPOSITORY}" --region "${AWS_REGION}" --profile "${AWS_PROFILE}" &> /dev/null; then
    echo "Repository does not exist. Creating repository ${ECR_REPOSITORY}..."
    aws ecr create-repository --repository-name "${ECR_REPOSITORY}" --region "${AWS_REGION}" --profile "${AWS_PROFILE}"
fi

# Build the Docker image with platform specified
echo "Building the Docker image..."
docker buildx build --platform linux/amd64 -t "${ECR_REPOSITORY}:${IMAGE_TAG}" -f Dockerfile .

# Tag the image for ECR
echo "Tagging the image for ECR..."
docker tag "${ECR_REPOSITORY}:${IMAGE_TAG}" "${ECR_REPOSITORY_URI}:${IMAGE_TAG}"

# Push the image to ECR
echo "Pushing the image to ECR..."
docker push "${ECR_REPOSITORY_URI}:${IMAGE_TAG}"

echo "Image successfully pushed to ${ECR_REPOSITORY_URI}:${IMAGE_TAG}"