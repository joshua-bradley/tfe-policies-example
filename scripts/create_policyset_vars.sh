#!/bin/bash

address="app.terraform.io"
organization="Patrick"

#TFC environment doesn't have jq.  using snap to install it for this script.
if [[ `hostname` =~ 'Patrick' ]]; then
  echo "Running Locally: skipping snap install jq"
else
  sudo snap install jq
  export PATH=$PATH:/snap:/snap/bin
fi

getid () {
  # takes 1 param : policyset name
  name=$1
  policy_id=$(curl -s --header "Authorization: Bearer $ATLAS_TOKEN" --header "Content-Type: application/vnd.api+json" --request GET "https://${address}/api/v2/organizations/${organization}/policy-sets" | jq -r ".data[] | select(.attributes.name | contains (\"${name}\")) | .id")
  echo "${policy_id}"
}

checkparam () {
  # takes 2 params : policyset id, variable name to look for
  policySetID=$1
  variableName=$2
  check=$(curl -s --header "Authorization: Bearer $ATLAS_TOKEN" --header "Content-Type: application/vnd.api+json" --request GET \
  "https://${address}/api/v2/policy-sets/${policySetID}/parameters" | jq -r ".data[] | select(.attributes.key | contains (\"${variableName}\")) | .id")
  
  #Note echo output will break the function so just use to test api output
  #echo "curl -s --header \"Authorization: Bearer $ATLAS_TOKEN\" --header \"Content-Type: application/vnd.api+json\" --request GET \
  #https://${address}/api/v2/policy-sets/${policySetID}/parameters | jq -r \".data[] | select(.attributes.key | contains (\"${variableName}\")) | .id\""

  if [[ $? == 0 ]]; then
    echo "${check}"
  else 
    echo ""
  fi
}

updateParam () {
  # takes 4 params: policyset id, key name, key value, boolean to enable/disable sensitive encryption
  policy_id=$1
  KEY_NAME=$2
  KEY_VALUE=$3
  SENSITIVE=$4

  echo "Adding Policy Variable ${KEY_NAME} to policyset_id: ${policy_id}"

  # Setup Payload
  sed -e "s/KEY_NAME/$KEY_NAME/" -e "s/KEY_VALUE/${KEY_VALUE}/" -e "s/SENSITIVE/${SENSITIVE}/" < policy-param-template.json > policy-param.json

  #POST
  curl -s --header "Authorization: Bearer $ATLAS_TOKEN" --header "Content-Type: application/vnd.api+json" --request POST --data @policy-param.json \
  "https://${address}/api/v2/policy-sets/${policy_id}/parameters"

  # Cleanup
  rm policy-param.json
}

# API Calls - Troubleshooting

# get policy id (org-policies)
 
echo "curl -s --header \"Authorization: Bearer $ATLAS_TOKEN\" --header \"Content-Type: application/vnd.api+json\" --request GET \"https://${address}/api/v2/organizations/${organization}/policy-sets\" | jq -r '.data[] | select(.attributes.name | contains (\"org-policies\")) | .id'"
#org_policies_id=$(curl -s --header "Authorization: Bearer $ATLAS_TOKEN" --header "Content-Type: application/vnd.api+json" --request GET "https://${address}/api/v2/organizations/${organization}/policy-sets" | jq -r '.data[] | select(.attributes.name | contains ("org-policies")) | .id')
#echo ${org_policies_id}

#echo "List Policy Params"
#curl -s --header "Authorization: Bearer $ATLAS_TOKEN" --header "Content-Type: application/vnd.api+json" --request GET \
#"https://${address}/api/v2/policy-sets/${org_policies_id}/parameters"

#echo "Check existing Param (organization)"
#organization_check=$(curl -s --header "Authorization: Bearer $ATLAS_TOKEN" --header "Content-Type: application/vnd.api+json" --request GET \
#"https://${address}/api/v2/policy-sets/${org_policies_id}/parameters" | jq -r '.data[] | select(.attributes.key | contains ("organization")) | .id')

# Add variable : organization
org_policies_id="$(getid 'org')"
check_organization=$(checkparam ${org_policies_id} "organization")
if [[ ${check_organization} != "" ]]; then
  echo "PolicySet Variable already exists in policyset_ID: ${org_policies_id}"
  echo "${check_organization}"
else
  updateParam ${org_policies_id} "organization" "Patrick" "false"
fi

# Add variable : tfe_token & enable encryption
org_policies_id="$(getid 'org')"
check_tfe_token=$(checkparam ${org_policies_id} "tfe_token")
if [[ ${check_tfe_token} != "" ]]; then
  echo "PolicySet Variable already exists in policyset_ID: ${org_policies_id}"
  echo "${check_tfe_token}"
else
  updateParam ${org_policies_id} "tfe_token" "${ATLAS_TOKEN}" "true"
fi 