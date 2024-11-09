#!/bin/bash

set_secret() {
  local secret_name=$1
  local secret_value=$2

  az keyvault secret set --vault-name $KEYVAULT_NAME --name $secret_name --value $secret_value
}

get_keyvault_name() {
  local environment=$1
  local keyvaults_file="keyvaults.json"
  jq -r --arg env "$environment" '.[$env]' $keyvaults_file
}

transform_key() {
  local key=$1
  echo "$key" | tr '[:upper:]_' '[:lower:]-'
}

read -p "Environment (dev, tst, acc) [dev]: " ENVIRONMENT
ENVIRONMENT=${ENVIRONMENT:-dev}

KEYVAULT_NAME=$(get_keyvault_name $ENVIRONMENT)

if [ "$KEYVAULT_NAME" == "null" ]; then
  echo "Invalid environment specified. Please specify one of: dev, tst, acc."
  exit 1
fi

read -p "Use secrets.env (1) or secrets.json (2) [1]: " FILE_TYPE
FILE_TYPE=${FILE_TYPE:-1}

read -p "Lowercase keys and replace '_' with '-' (1) or not change keys (2) [1]: " TRANSFORM_MODE
TRANSFORM_MODE=${TRANSFORM_MODE:-1}

if [ "$FILE_TYPE" == "2" ]; then
  SECRETS_FILE="secrets.json"

  if [ ! -f $SECRETS_FILE ]; then
    echo "Secrets file '$SECRETS_FILE' not found!"
    exit 11
  fi

  for row in $(jq -r 'to_entries|map("\(.key)=\(.value|tostring)")|.[]' $SECRETS_FILE); do
    secret_name=$(echo $row | cut -d= -f1)
    secret_value=$(echo $row | cut -d= -f2)

    if [ "$TRANSFORM_MODE" == "1" ]; then
      secret_name=$(transform_key $secret_name)
    fi

    set_secret $secret_name $secret_value
  done

elif [ "$FILE_TYPE" == "1" ]; then
  SECRETS_FILE="secrets.env"

  if [ ! -f $SECRETS_FILE ]; then
    echo "Secrets file '$SECRETS_FILE' not found!"
    exit 1
  fi

  while IFS='=' read -r secret_name secret_value; do
    if [ -n "$secret_name" ] && [ -n "$secret_value" ]; then
      if [ "$TRANSFORM_MODE" == "1" ]; then
        secret_name=$(transform_key $secret_name)
      fi
      set_secret $secret_name $secret_value
    fi
  done < $SECRETS_FILE

else
  echo "Invalid file type selected. Please enter 1 or 2."
  exit 1
fi
