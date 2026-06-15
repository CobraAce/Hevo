# Hevo Data Interview Exercise

## Overview
This was created to demonstrates a data pipeline built with PostgreSQL, Hevo, Snowflake, and dbt.

## Architecture
PostgreSQL (Docker) → Hevo Pipeline → Snowflake → dbt transformation

## Prerequisites
- Docker Desktop
- PostgreSQL (running as Docker container)
- Hevo account (signed up directly at https://hevodata.com as free trial, 
  not via Snowflake Partner Connect due to connectivity issues as recommended by Snowflake support)
- Snowflake trial account
- dbt-snowflake installed

## Setup Instructions

### 1. PostgreSQL Setup
```bash
docker run --name kumarpostgre -e POSTGRES_PASSWORD=your_password -p 5432:5432 -d postgres
```

### 2. Enable Logical Replication
```bash
docker exec -it kumarpostgre bash
echo "wal_level = logical" >> /var/lib/postgresql/data/postgresql.conf
```

### 3. Load CSV Data
Load the three CSV files into the following tables:
- raw_customers
- raw_orders
- raw_payments

### 4. Hevo Pipeline
- Source: PostgreSQL using Logical Replication
- Destination: Snowflake

### 5. dbt Setup
```bash
pip3 install dbt-snowflake
dbt init jaffle_shop
dbt run
dbt test
```

## dbt Model
The `customers` materialized table includes:
- customer_id
- first_name
- last_name
- first_order
- most_recent_order
- number_of_orders
- customer_lifetime_value

## dbt Tests
- unique: customer_id
- not_null: customer_id, first_name

## Important Note
No credentials or sensitive information are hardcoded in this project.
All credentials must be configured in ~/.dbt/profiles.yml locally.