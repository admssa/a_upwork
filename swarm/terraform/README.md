### Docker swarm install

backends: contains keys to store state to s3 bucket

utils: contains terraform commands to use with specific backend. example:

```
./urils/tfinit.sh dev
./utils/tfplan.sh dev
./utils/tfapply.sh dev
```

vars: contains variables for specific backend

#### Files list which should be changed before run:
  - ./backends/backend-dev.json
  - ./main.tf (s3 bucket only)
  - ./vars/dev.tfvars

 