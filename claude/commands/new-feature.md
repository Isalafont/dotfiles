# New Feature Command

Implement a new feature following DataPass development workflow:

1. **Planning Phase**
   - Understand requirements (ask questions if unclear)
   - Identify affected models, controllers, services
   - Design database changes if needed
   - Plan test strategy

2. **Implementation Order**

   **Step 1: Models**
   - Create/modify models
   - Add validations and associations
   - Write model specs (focus on behavior, not associations)
   - Run tests: `bundle exec rspec spec/models/`
   - Run rubocop: `bundle exec rubocop -A`

   **Step 2: Services/Organizers**
   - Create services or organizers for business logic
   - Write service specs
   - Run tests: `bundle exec rspec spec/services/` or `spec/organizers/`
   - Run rubocop: `bundle exec rubocop -A`

   **Step 3: Controllers & Views**
   - Implement RESTful controllers
   - Add authorization in controllers
   - Create views
   - Run tests: `bundle exec rspec spec/controllers/` (if needed)
   - Run rubocop: `bundle exec rubocop -A`

   **Step 4: Cucumber Features**
   - Write end-to-end cucumber scenarios
   - Run features: `bundle exec cucumber features/path/to/feature.feature`
   - Ensure all scenarios pass

3. **Validation**
   - Run all spec tests: `bundle exec rspec spec`
   - Run all E2E tests: `bundle exec cucumber`
   - Verify rubocop passes
   - Test manually if needed

4. **Refactoring**
   - Review code for DRY violations
   - Extract methods if needed (max 15 lines)
   - Ensure meaningful names (no comments)
   - Re-run tests after refactoring

Stop at each step to ensure tests pass before proceeding.
