# Take-home project

The goal of this project is to demonstrate my skills in Go and Terraform.

This project provides a Makefile to simplify the steps. By running `make help` you will see the available targets:

```bash
Available targets:
          plan: runs terragrunt plan
         apply: runs terragrunt apply
       destroy: runs terragrunt destroy
 fetch_secrets: runs the bash scripts that retrives all the secrets
```

##### PREREQUISITES

Declare some environment variables as follows:

```bash
$ export AWS_ACCESS_KEY_ID=<YOUR_AWS_ACCESS_KEY_ID>
$ export AWS_SECRET_ACCESS_KEY=<YOUR_AWS_SECRET_ACCESS_KEY>
$ export AWS_DEFAULT_REGION=us-east-2
```
### Take-home coding task #1
This task intends to create a small HTTP server that consumes [**mateo-api**](https://open-meteo.com/) and shows the Temperature and Wind Speed in a simple web page.
Since mateo only works with Latitude and Longitude the application uses [**locationiq**](https://docs.locationiq.com/reference/search) to get them by passing city and state information.

To run the code, use the `go run` command, like:
```bash
$ go run weather.go
```
Then visit http://localhost:8080/?city=Boca+Raton&state=FL in your browser to see the response!


- Modules and Tools
  - github.com/gin-gonic/gin - Could have used github.com/gorilla/mux, but decided for gin to experience a different framework.
  - github.com/go-resty/resty - Simple HTTP and REST client library for Go
  - Needed a tool that provides Latitude and Longitude by passing city and state. I decided to use [**locationiq**](https://docs.locationiq.com/reference/search) since it provides a free version of 5000 requests /day or 2 requests /second.

#### References
- To write the gin code https://github.com/gin-gonic/gin?tab=readme-ov-file#running-gin
- Template https://github.com/golang/example/blob/master/template/

#### Improvements
- Create a docker file to build and run the application to isolate the environment.
- Store the locationiq token in a safe place instead of hardcode in the coe.
- Mock up the tests

### Take-home coding task #2

- Terraform module for deploying desired secrets into AWS Secrets Manager.
- The code is placed at [**terraform**](./terraform) folder.
- The script to fetch all the secrets created is placed at [**scripts**](./scripts) folder.
- To create the secrets run:
  ```bash
  $ make apply
  ```
- To fetch the secrets run:
  ```bash
  $ make fetch_secrets
  ```
## Lessons learnt

- If you don't set `recovery_window_in_days` to 0 in the aws_secretsmanager_secret resource you are not going to be able
  to destroy and recreate the secret because AWS Secrets Manager will wait 30 days by default before it can delete the
  secret.
  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret#recovery_window_in_days

```
Error:
16:57:44.944 STDOUT terraform: │ Error: creating Secrets Manager Secret (testing/secret2): operation error Secrets Manager: CreateSecret, https response error StatusCode: 400, RequestID: 6cd2036f-07aa-469a-80ab-5380e78a5c68, InvalidRequestException: You can't create this secret because a secret with this name is already scheduled for deletion.
16:57:44.944 STDOUT terraform: │
16:57:44.944 STDOUT terraform: │   with aws_secretsmanager_secret.secrets["secret2"],
16:57:44.944 STDOUT terraform: │   on main.tf line 1, in resource "aws_secretsmanager_secret" "secrets":
16:57:44.944 STDOUT terraform: │    1: resource "aws_secretsmanager_secret" "secrets" {
16:57:44.944 STDOUT terraform: │
16:57:44.944 STDOUT terraform: │ Error: creating Secrets Manager Secret (testing/secret1): operation error Secrets Manager: CreateSecret, https response error StatusCode: 400, RequestID: 1e8b02b5-227a-4216-b577-860b287a063a, InvalidRequestException: You can't create this secret because a secret with this name is already scheduled for deletion.
16:57:44.944 STDOUT terraform: │
16:57:44.944 STDOUT terraform: │   with aws_secretsmanager_secret.secrets["secret1"],
16:57:44.944 STDOUT terraform: │   on main.tf line 1, in resource "aws_secretsmanager_secret" "secrets":
16:57:44.944 STDOUT terraform: │    1: resource "aws_secretsmanager_secret" "secrets" {

https://us1.locationiq.com/v1/search?key=pk.f39ed97163f550902baa141600a39309&city=Boca%20Raton&state=Florida&format=json&
```