# CI/CD & Docker Challenge
---

## CASE-STUDY
Our Engineering team have produced an application which now needs to be automatically built and deployed using a fully automated CI & CD Process. The team have asked us to help with this solution.

---

## Task 1: Creating a Docker file

You have been asked to create a `docker` file which will run the application which is written using `react` and the lts node version `node 14.15.1`. The file should:
  - Install node modules within the Docker image only
  - Run the application (uses npm start) exposed on port `3000`
### Result Format

The result will consist of:
- Docker file with the necessary steps

---
## Task 2: Build and Release Pipelines

### The Challenge
Create a build and release pipeline which:
  - Builds the code appropriately using `npm run build`
  - Builds the Docker image
  - Deploy the application to three environments `dev`, `qa` and `prod`

### Result Format

The result will consist of:
- CI&CD code as `yaml` using an an Application Lifecycle Management tool of your choice (preferably AzureDevOps) 
- Dry-run file in `md` format wherever the CI/CD code has not been provided as code.
- Documentation and explanation where necessary, committed to this repo.
