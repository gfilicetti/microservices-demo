#!/bin/zsh
# NOTE!! This script outputs env var export commands, you must run it with eval
# eg: eval $(./aws-auth.sh 666666)
# inspired by: https://aws.amazon.com/premiumsupport/knowledge-center/authenticate-mfa-cli/

# parameters
TOKEN=$1
SERIAL="arn:aws:iam::418892013406:mfa/ginof"

# First unset the session variables because you can not make a credentials call from an active session
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN

# now make the call to get the session
RAWCREDS=`aws sts get-session-token --serial-number $SERIAL --token-code $TOKEN`

# output the environment variables that need to be set
echo "export AWS_ACCESS_KEY_ID=`echo $RAWCREDS | jq -r '.Credentials.AccessKeyId'`"
echo "export AWS_SECRET_ACCESS_KEY=`echo $RAWCREDS | jq -r '.Credentials.SecretAccessKey'`"
echo "export AWS_SESSION_TOKEN=`echo $RAWCREDS | jq -r '.Credentials.SessionToken'`"
# export AWS_ACCESS_KEY_ID=`echo $RAWCREDS | jq -r '.Credentials.AccessKeyId'`
# export AWS_SECRET_ACCESS_KEY=`echo $RAWCREDS | jq -r '.Credentials.SecretAccessKey'`
# export AWS_SESSION_TOKEN=`echo $RAWCREDS | jq -r '.Credentials.SessionToken'`