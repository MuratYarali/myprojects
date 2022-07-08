PATH="$PATH:/usr/local/bin"
APP_NAME="petclinic"
ANS_KEYPAIR="matt-${APP_NAME}-qa.key"
AWS_REGION="us-east-1"
aws ec2 create-key-pair --region ${AWS_REGION} --key-name ${ANS_KEYPAIR} --query "KeyMaterial" --output text > ${ANS_KEYPAIR}
chmod 400 ${ANS_KEYPAIR}
mkdir -p ${JENKINS_HOME}/.ssh
mv ${ANS_KEYPAIR} ${JENKINS_HOME}/.ssh/${ANS_KEYPAIR}
ls -al ${JENKINS_HOME}/.ssh