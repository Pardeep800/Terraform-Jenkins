pipeline {
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        string(name: 'tag', defaultValue: '', description: 'Tag for the resources')
        string(name: 'amiId', defaultValue: '', description: 'AMI ID for the instance')
        string(name: 'cidr', defaultValue: '', description: 'CIDR block for the VPC')
        string(name: 'subnet', defaultValue: '', description: 'Subnet for the resources')
    }
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    agent any
    stages {
        stage('checkout') {
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
                sh 'pwd; cd terraform/; terraform init'
                sh "pwd; cd terraform/; terraform plan -out tfplan -var 'tag=${params.tag}' -var 'ami_id=${params.amiId}' -var 'cidr=${params.cidr}' -var 'subnet=${params.subnet}'"
                sh 'pwd; cd terraform/; terraform show -no-color tfplan > tfplan.txt'
            }
        }

        stage('Approval') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
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
                sh "pwd; cd terraform/; terraform apply -input=false tfplan"
            }
        }
    }
}
