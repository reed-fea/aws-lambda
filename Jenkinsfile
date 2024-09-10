pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID = '156735276734'
        AWS_REGION = 'cn-northwest-1'
    }

    stages {
        stage('Initialize') { steps { script { initialize() } } }
        stage('Build Docker Image') { steps { script { buildImage() } } }
        stage('Setup AWS CLI') { steps { script { setupAWSCLI() } } }
    }
}

// Initialize stage
def initialize() {
  echo 'Initializing...'
  env.SERVICE_NAME = 'ph-data-collection'
  env.IMAGE_REPO_NAME = "philips-lab/${env.SERVICE_NAME}"
  env.IMAGE_TAG = "${params.ENVIRONMENT}-${generateTimestamp()}"
  env.DOCKER_IMAGE_REPO = "${env.AWS_ACCOUNT_ID}.dkr.ecr.${env.AWS_REGION}.amazonaws.com.cn/${env.IMAGE_REPO_NAME}"
  env.DOCKER_IMAGE_SOURCE = "${env.DOCKER_IMAGE_REPO}:${env.IMAGE_TAG}"
  env.YAML_FILE = "${env.WORKSPACE}/build/deployment/${env.SERVICE_NAME}-${params.ENVIRONMENT}.yaml"
  echo "本次编译的镜像 TAG_ID 为 ${env.IMAGE_TAG}"
  echo "镜像仓库名称为 ${env.IMAGE_REPO_NAME}"
  echo "Docker 镜像源地址为 ${env.DOCKER_IMAGE_SOURCE}"
}

// Function to build Docker image
def buildImage() {
  echo "Building Docker image..."
  sh """
        docker build -t ${env.DOCKER_IMAGE_SOURCE} .
    """
  echo 'Build success'
}

// Function to setup AWS CLI and login to ECR
def setupAWSCLI() {
  withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-id']]) {
        sh '''
            docker run --rm \
                -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
                -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
                -e AWS_DEFAULT_REGION=${AWS_REGION} \
                public.ecr.aws/aws-cli/aws-cli:latest ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com.cn
        '''
  }
}

// Function to generate a timestamp
def generateTimestamp() {
  return sh(script: 'date +%Y%m%d%H%M%S', returnStdout: true).trim()
}
