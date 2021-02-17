### Library Management System
Playground for testing go -> terraform -> serverless

1. `frontend/` dir holds web interface parts. To run it `yarn install && yarn start`
2. `cmd/` holds programs/lambdas as per one of my favourites [repository structures](https://peter.bourgon.org/go-best-practices-2016/?ref=hackernoon.com#repository-structure)
3. `pkg/` holds packages that will be reused by programs from `/cmd` dir
4. `modules/` holds reusable terraform modules
5. `prod/` is one of many available stacks that will hold the infrastructure
   setup code for production environment. More can be added: `['staging', 'dev']`
   and with different `variables.tf` we can spin up environment to play with.
   Each stack will have `remote_state` folder that will hold and keep track of
   terraform state remotely in S3 bucket. So this has to be initiated first:
   `cd prod/remote_state && terraform plan && terraform apply -auto-approve`
   Then stack can be deployed:
   `cd prod && terraform init && ./deploy.sh`

### Note on book model
It contains changelog field and each time book instance is updated, changelog
is populated with changes made to book. This is almost like pseudo event
sourcing and can be used to revert book to certain state.
