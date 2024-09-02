#/bin/bash

secretsArray=$(aws secretsmanager list-secrets --output json | jq -r '.SecretList[] | "\(.Name)|\(.ARN)"')
for str in ${secretsArray[@]}; do
  IFS='|'; arrIN=($str); unset IFS;
  echo ${arrIN[0]}
  echo $(aws secretsmanager get-secret-value --secret-id ${arrIN[1]} | jq -r '.SecretString' | tr -d '[:space:]' | sed 's/"/\\"/g')
done