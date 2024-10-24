pipeline {
    agent any

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        string(name: 'tag', defaultValue: 'Terraform', description: 'Tag for the resources')
        string(name: 'amiId', defaultValue: 'ami-06b21ccaeff8cd686', description: 'AMI ID for the instance')
        string(name: 'cidr', defaultValue: '172.31.32.0/20', description: 'CIDR block for the VPC')
        string(name: 'subnet', defaultValue: 'subnet-0285c1a6c843aa9e0', description: 'Subnet for the resources')
        string(name: 'vpc', defaultValue: 'vpc-0f9bd6a752d53cff6', description: 'VPC ID for use')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    dir("terraform") {
                        git "https://github.com/yeshwanthlm/Terraform-Jenkins.git"
                    }
                }
            }
        }

        stage('Plan') {
            steps {
                script {
                    dir("terraform") {
                        sh 'terraform init'
                        sh """
                        terraform plan -out=tfplan \
                        -var 'tag=${params.tag}' \
                        -var 'ami_id=${params.amiId}' \
                        -var 'cidr=${params.cidr}' \
                        -var 'subnet=${params.subnet}' \
                        -var 'vpc=${params.vpc}'
                        """
                        sh 'terraform show -no-color tfplan > tfplan.txt'
                    }
                }
            }
        }

        stage('Approval') {
            when {
                not {
                    expression { params.autoApprove }
                }
            }
            steps {
                script {
                    def plan = readFile 'terraform/tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                }
            }
        }

        stage('Apply') {
            steps {
                script {
                    dir("terraform") {
                        sh 'terraform apply -input=false tfplan'
                    }
                }
            }
        }
    }
}
