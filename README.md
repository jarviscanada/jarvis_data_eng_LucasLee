# Introduction

The purpose of this repository is to build and deploy Shell scripts to automatically monitor Linux resource usage in real-time to then create reports for future resource planning projects.

It incorporates [Bash scripts](https://en.wikipedia.org/wiki/Bash_(Unix_shell)), [PostgreSQL](https://www.postgresql.org/), [Docker](https://www.docker.com/), and [Crontab](https://en.wikipedia.org/wiki/Cron). The SQL queries will build PostgreSQL tables to hold the data while the Bash scripts will run standardized templates to run custom commands within a Docker container. Crontab is used to automatically run the scripts.

All of the code within this repository is expected to run on a Rocky Linux 9 x86 64-bit machine. Using other operating systems such as MacOS or Windows is currently not supported and thus may cause issues if it were to run on said environments. 

# Quick Start

Start a PSQL instance with Docker

```bash
su rocky

docker container start jrvs-psql
```
- Start a psql instance using psql_docker.sh
- Create tables using ddl.sql

```bash

```
- Insert hardware specs data into the DB using host_info.sh
- Insert hardware usage data into the DB using host_usage.sh
- Crontab setup

# Implemenation
Discuss how you implement the project.
## Architecture
Draw a cluster diagram with three Linux hosts, a DB, and agents (use draw.io website). Image must be saved to the `assets` directory.

## Scripts
Shell script description and usage (use markdown code block for script usage)
- psql_docker.sh
- host_info.sh
- host_usage.sh
- crontab
- queries.sql (describe what business problem you are trying to resolve)

## Database Modeling
Describe the schema of each table using markdown table syntax (do not put any sql code)
- `host_info`
- `host_usage`

# Test
How did you test your bash scripts DDL? What was the result?

# Deployment
How did you deploy your app? (e.g. Github, crontab, docker)

The repository's source code is hosted on GitHub.

Docker is used to build 

Crontab is used to run automated scripts.

# Improvements
Write at least three things you want to improve 
e.g. 
- handle hardware updates 
- blah
- blah
