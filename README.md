# Project Conversation

## Project Description

Project Conversation is a web application for project management with a focus on tracking change history and communication. The application allows users to create projects, leave comments, and change project statuses while maintaining a complete history of all actions in chronological order.

Deployed on fly.io - https://project-conversation.fly.dev

## Tech Stack

- Ruby on Rails 8.0.2
- PostgreSQL
- Tailwind CSS
- Slim templates
- ViewComponent
- Importmap
- Stimulus
- Turbo
- RSpec for testing

## Key Features

- User authentication (registration, login, logout)
- Creating and viewing projects
- Adding comments to projects
- Changing project statuses
- Chronological history of all project actions
- Dynamic interface updates using Turbo Streams

## Installation and Setup

### Requirements

- Ruby 3.3.0+
- PostgreSQL 14+
- Node.js 18+
- Yarn 1.22+

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/project_conversation.git
cd project_conversation

# Install dependencies
bundle install

# Set up the database
rails db:create db:migrate db:seed

# Start the server
rails server
rails tailwindcss:watch
```

The application will be available at http://localhost:3000

## Application Architecture

The application is built using the MVC (Model-View-Controller) pattern with additional layers:

- **Models**: Thin models responsible only for data and validations
- **Views**: Slim templates and ViewComponent components for data presentation
- **Controllers**: Controllers handling requests and delegating business logic to services
- **Services**: Service objects containing business logic

## Discussion Questions for Colleagues

### 1. What problem does Project Conversation solve?

#### Expected answer:

The application solves the problem of lack of transparency in project communication. Often, project information is scattered across different channels (email, messengers, documents), making it difficult to track the history of changes and decisions made.

### 2. Who are the primary users of the application?

#### Expected answer:

Project teams, project managers, developers, and other stakeholders who need to track progress and communication on projects.

### Functional Requirements

### 3. What project statuses should be supported?

#### Expected answer:

Basic statuses include: "Created", "In Progress", "On Hold", and "Completed". In the future, we may add the ability to create custom statuses.

### 4. Are additional attributes needed for projects besides title and status?

#### Expected answer:

For the first phase, basic attributes are sufficient: title, description, and status.

### 5. Is integration with other systems required (Slack, Email, Jira)?

#### Expected answer:

Not in the first phase.

### Technical Requirements

### 6. What are the performance and scalability requirements?

#### Expected answer:

In the initial phase, up to 1,000 active users are expected. The system should be able to handle up to 100 concurrent requests without noticeable performance degradation.

### 7. What are the security requirements?

#### Expected answer:

Standard security measures for web applications: authentication, authorization, protection against XSS and CSRF attacks. Project data may contain confidential information, so it's important to ensure proper access control.

### User Experience

### 8. What are the most important user flows in the application?

#### Expected answer:

The key flows are: creating a project, adding comments, changing project status, and viewing the conversation history in chronological order.

### Development and Deployment

### 9. How will the application be deployed and hosted?

#### Expected answer:

The application will be deployed on fly.io for the initial release, with potential migration to AWS as we scale.

## Future Development

- Adding a tag system for projects
- Implementing search and filtering
- Integration with external services (Slack, Email)
- Creating an API for mobile applications
- Adding analytics and reports
- Improving UX/UI with a focus on accessibility
