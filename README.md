Optimal Distribution of Resources - Client
==========================================

# Introduction

Optimal Distribution of Resources (ODR) Client is a sample client application that consumes ODR API.

It provides two possible user inputs:
* Manual input of a graph adjacency matrix
* Selection of a map area using Open Street Maps

# Start Application Locally

Docker takes care of running every needed dependecy:

```
docker-compose up
```

Here is what is included in the docker-compose stack:
* MySQL
* Redis
* Rails server (puma)
* Sidekiq

This application runs on domain `localhost` and port `3000`.

## Rails: create and seed database

To create and seed your database, run:

```
docker-compose exec app rails db:reset
```

## Admin Dashboard

* Visit http://localhost:3000/admin
  * Username: `admin@example.com`
  * Password: `password`

## Sidekiq Dashboard

* Visit http://localhost:3000/sidekiq
  * Username and password are the same as in the previous section: `admin@example.com`, `password`
