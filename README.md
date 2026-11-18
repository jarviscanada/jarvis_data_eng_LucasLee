# Introduction

The purpose of this repository is to build and deploy Shell scripts to automatically monitor Linux resource usage in real-time to then create reports for future resource planning projects.

It incorporates [Bash scripts](https://en.wikipedia.org/wiki/Bash_(Unix_shell)), [PostgreSQL](https://www.postgresql.org/), [Docker](https://www.docker.com/), and [Crontab](https://en.wikipedia.org/wiki/Cron). The SQL queries will build PostgreSQL tables to hold the data while the Bash scripts will run standardized templates to run custom commands within a Docker container. Crontab is used to automatically run the scripts.

All of the code within this repository is expected to run on a Rocky Linux 9 x86 64-bit machine. Using other operating systems such as MacOS or Windows is currently not supported and thus may cause issues if it were to run on said environments.

# Quick Start

Start a PSQL instance with Docker

```bash
su rocky

sudo systemctl status docker || sudo systemctl start docker

docker pull postgres

docker container start jrvs-psql
```

- Create tables using ddl.sql

```bash
# From the root folder of the repository, run the following command:

psql -h localhost -U postgres -d host_agent -f sql/ddl.sql
```
- Insert hardware specs data into the DB using host_info.sh

```bash
./scripts/host_info.sh psql_host psql_port db_name psql_user psql_password


bash scripts/host_usage.sh psql_host psql_port db_name psql_user psql_password
```

- Insert hardware usage data into the DB using host_usage.sh
- Crontab setup

```bash
crontab -e

# Once you're in Crontab, enter this command:
* * * * * bash /home/rocky/jarvis_data_eng_LucasLee/host_usage.sh localhost 5432 host_agent postgres password > /tmp/host_usage.log

# Leave crontab and check if it is inserted:
```

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

### `host_info`

| **Column Name** | **Data Type** | **Description** |
|---|---|---|
| `id` | `SERIAL` (auto-incrementing integer), NOT NULL | Automatically built unique identifier for each row |
| `hostname` | `VARCHAR`, NOT NULL | Host machine's name |
| `cpu_number` | `INT2`, NOT NULL | Number of CPUs on the host |
| `cpu_architecture` | `VARCHAR`, NOT NULL | CPU architecture, e.g. `x86_64`, `arm64`, etc. |
| `cpu_model` | `VARCHAR`, NOT NULL | Model name of the CPU, e.g. `Intel(R) Xeon(R) CPU @ 2.30GHz` |
| `cpu_mhz` | `FLOAT8`, NOT NULL | CPU clock speed in MHz |
| `l2_cache` | `INT4`, NOT NULL | Size of the CPU's L2 cache in KB |
| `"timestamp"` | `TIMESTAMP`, NULL | Date and time the record was collected |
| `total_mem` | `INT4`, NULL | Total memory on the host in KB |

### `host_usage`

| **Column Name** | **Data Type** | **Description** |
|---|---|---|
| `"timestamp"` | `TIMESTAMP`, NOT NULL | Date and time the record was collected |
| `host_id` | `SERIAL`, NOT NULL | Foreign key referencing `host_info(id)` to identify which host the usage data belongs to |
| `memory_free` | `INT4`, NOT NULL | Amount of free memory on the host in MB |
| `cpu_idle` | `INT2`, NOT NULL | Percentage of CPU time spent idle |
| `cpu_kernel` | `INT2`, NOT NULL | Percentage of CPU time spent running the kernel |
| `disk_io` | `INT4`, NOT NULL | Number of disk I/O operations currently in progress |
| `disk_available` | `INT4`, NOT NULL | Available disk space on the host in MB |

# Test
How did you test your bash scripts DDL? What was the result?

# Deployment

The repository's source code is hosted on GitHub.

Docker is used to connect ``postgres:9.6-alpine`` and create a container from it.

Crontab is used to run automated scripts.

# Improvements

- Handle hardware updates
- Create functions for scripts because some of the code is repeated
- Build a frontend to more easily view the database
