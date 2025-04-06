# This file creates seed data for the application

# Clear existing data
puts "Cleaning database..."
ConversationEntry.destroy_all
Comment.destroy_all
StatusChange.destroy_all
Project.destroy_all
User.destroy_all

# Create users
puts "Creating users..."
user1 = User.create!(
  name: "John Doe",
  email: "john@example.com",
  password: "password",
  password_confirmation: "password"
)

user2 = User.create!(
  name: "Jane Smith",
  email: "jane@example.com",
  password: "password",
  password_confirmation: "password"
)

# Create projects
puts "Creating projects..."
project1 = Project.create!(
  title: "Website Redesign",
  description: "Redesign the company website with a modern look and improved user experience.",
  status: :in_progress
)

project2 = Project.create!(
  title: "Mobile App Development",
  description: "Develop a new mobile app for both iOS and Android platforms.",
  status: :created
)

project3 = Project.create!(
  title: "Database Migration",
  description: "Migrate the existing database to a new cloud-based solution.",
  status: :completed
)

# Create comments and status changes for the first project
puts "Creating conversation history..."

# Initial status change (automatically created when project is created)
StatusChange.create!(
  from_status: :created,
  to_status: :in_progress,
  reason: "Ready to begin work",
  user: user1,
  project: project1,
  created_at: 3.days.ago
)

# Comments
Comment.create!(
  content: "I've started working on the wireframes for the homepage.",
  user: user1,
  project: project1,
  created_at: 2.days.ago
)

Comment.create!(
  content: "The wireframes look great! Let's schedule a meeting to discuss them further.",
  user: user2,
  project: project1,
  created_at: 1.day.ago
)

Comment.create!(
  content: "I've updated the color scheme based on our discussion.",
  user: user1,
  project: project1,
  created_at: 12.hours.ago
)

# Create comments and status changes for the second project
Comment.create!(
  content: "We need to define the requirements for this project before we start.",
  user: user2,
  project: project2,
  created_at: 5.days.ago
)

Comment.create!(
  content: "I've prepared a draft of the requirements document. Please review when you have time.",
  user: user1,
  project: project2,
  created_at: 4.days.ago
)

# Create comments and status changes for the third project
StatusChange.create!(
  from_status: :created,
  to_status: :in_progress,
  reason: "Starting the migration process",
  user: user2,
  project: project3,
  created_at: 10.days.ago
)

StatusChange.create!(
  from_status: :in_progress,
  to_status: :completed,
  reason: "All data has been successfully migrated and verified",
  user: user2,
  project: project3,
  created_at: 2.days.ago
)

Comment.create!(
  content: "The migration has been completed successfully. All systems are now using the new database.",
  user: user2,
  project: project3,
  created_at: 1.day.ago
)

puts "Seed data created successfully!"
