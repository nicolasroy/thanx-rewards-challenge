# Thanx Rewards Challenge by Nicolas Roy

## Design

### Key Entities

- **User**, places many **Orders**
- **Order**, contains one or many **LineItem**
- **LineItem**, references a polymorphic itemizable which can be a **Reward**
- **Reward**
- **Point**, with can be either an **Earning** (account credit) or a **Redemption** (account debit). Optionally it can be originated by an **Order**.

### Basic API

- POST /orders, creates an order for reedeeming a reward
- GET /rewards, list rewards
- GET /redemptions, list history of previous redemptions

### Out of Scope

- Cart experience.
- Order lifecycle. An order would asynchronously go trough different states until it completes. In such case, point Redemptions could be pending untill the order is processed.
- Background jobs. Would be used with an order lifecycle.
- Non-reward items. These would normally earn new points.
- Quantities per Line Item. To keep the scope small, only one reward is redeemed per order.
- Tiered rewards.
- Point expiration.

## Installation

### Prerequisites

- Install the latest [Docker for Mac](https://docs.docker.com/desktop/install/mac-install/) so you can run the database in a container
- Install [Brew](https://brew.sh/) to install required dev dependencies during `bin/setup`
- Install a version manager such as
  - [Mise](https://mise.jdx.dev/installing-mise.html)
  - [asdf](https://github.com/asdf-vm/asdf) with the [nodejs](https://github.com/asdf-vm/asdf-nodejs) and [Ruby](https://github.com/asdf-vm/asdf-ruby) plugin, with support for the .ruby-verion file [turned on](https://github.com/asdf-vm/asdf-ruby?tab=readme-ov-file#ruby-version-file)
- Install ruby & node with your version manager which `mise install` or `asdf install`

### Setup

- Get started by running `bin/setup` which will install dependencies and start the services.
- Run `rails db:seed:replant` for a fresh set of sample data.
- The application is available at http://127.0.0.1:3000/, You'll get automatically logged in while in a development environment.

## Development

- Run `rails tests`
- Use `rubocop`
- To verify the empty states, remove the seeded Points with `rails runner "Point.destroy_all"`
