# License Flow

License management system for subscription control and product license distribution to users organized by accounts.


## ⚠️ Development Notes

### Architecture Considerations

Given more development time, I would have preferred to implement the `license_assignment` functionality using **Service Objects** to keep the controllers cleaner and follow Single Responsibility Principle more strictly. However, due to time constraints, I focused on delivering a working solution within the allocated timeframe.

**Future improvements would include:**
- Extract business logic from `LicenseAssignmentsController` into dedicated service classes
- Implement service objects for batch operations (`CreateBatchAssignmentsService`, `DestroyBatchAssignmentsService`)
- Add more comprehensive error handling and logging
- Implement background job processing for bulk operations

The current implementation prioritizes functionality and meets the core requirements, while maintaining code readability and test coverage.

## 📋 About the Project

License Flow is a Rails application that provides:

- **Account Management**: Organization of users by business accounts
- **Product Control**: Registration and management of licensable products
- **Subscriptions**: Management of product subscriptions per account with license quantity control
- **License Assignment**: Intelligent distribution of licenses to specific users
- **Administrative Interface**: Complete panel for system administration

## 🛠 Technologies

- **Ruby**: 3.2.2
- **Rails**: 8.0.2+
- **Database**: PostgreSQL 15
- **Frontend**: Stimulus, Turbo, Importmap
- **Testing**: RSpec, FactoryBot, Capybara
- **Code Quality**: RuboCop, Brakeman
- **Containerization**: Docker & Docker Compose

## 🗂 Project Structure

```
license_flow/
├── app/
│   ├── controllers/admin/          # Administrative controllers
│   ├── models/                     # Data models
│   ├── views/admin/               # Administrative views
│   └── javascript/                # JavaScript/Stimulus code
├── config/                        # Rails configurations
├── db/migrate/                    # Database migrations
├── spec/                          # RSpec tests
└── docker-compose.yml             # Docker configuration
```

## 🚀 Setup and Execution

### Prerequisites

- Docker
- Docker Compose

### Running with Docker

1. **Clone the repository:**
```bash
git clone https://github.com/breim/license_flow
cd license_flow
```

2. **Start the services:**
```bash
docker compose up
```

3. **To run in background:**
```bash
docker compose up -d
```

4. **To stop the services:**
```bash
docker compose down
```

### 🌐 Application Access

After running `docker compose up`, the application will be available at:

**http://localhost:3000**

The home page automatically redirects to the administrative panel at:
**http://localhost:3000/admin/accounts**

### 🗄 Database

Docker Compose automatically configures:

- **PostgreSQL 15** on port `5432`
- **Database**: `license_flow_development`
- **Username**: `license_flow`
- **Password**: `password`

The database is automatically initialized with:
- Table creation (`rails db:create && rails db:migrate`)
- Sample data (`rails db:seed`)

## 🔧 Useful Commands

### Docker

```bash
# With docker compose
docker compose up

# Clean volumes (remove database data)
docker compose down -v
```

### Local Development (without Docker)

If you prefer to run locally:

```bash
# Install dependencies
bundle install

# Setup database
rails db:create db:migrate db:seed

# Start server
rails server
```

## 🧪 Testing

Run tests

```bash
bundle exec rspec
```

Or with documentation format:

```bash
bundle exec rspec --format documentation
```
