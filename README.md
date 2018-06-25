# Time Manager backend layer and services
This project hosts the backend graphql server which offers a layer of security and functionality
over the Prisma bindings. The application is written in typescript and is containerized in 
Docker for simplicity of usage and deployment.

The services folder contains the necessary terraform code to deploy the infrastructure 
over the Nomad cluster. To use the tools you have to have an open shuttle as explained in the 
[tm-infrastructure](https://github.com/mimacom/tm-infrastructure) project.
