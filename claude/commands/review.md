# Review Command

Review Checklist:

1. **Review Guidelines**
   - Check on github the latest review and make a plan to address the comments.
   - Use gh to check the latest review on this branch.
   - It should be exhaustive and cover all issues, one by one.
   - For each issue, put a "Should be addressed?" question, so that I can answer it. 
   - If you have any questions please put them at the end of the plan and ask clarification. 
   - Write this plan into review-plan.md, if it does already exists, rewrite it.

2. **Code Quality**
   - Check for DRY violations
   - Look for complex methods that need extraction
   - Verify RESTful controller patterns
   - Check for proper error handling
   - Verify meaningful variable/method names

3. **Testing**
   - Verify test coverage for new code
   - Check test structure matches application structure
   - Check for behavior testing (not just associations/validations)

4. **Rails Best Practices**
   - Check authorization in controllers (not models/services)
   - Verify service/organizer usage
   - Check for N+1 queries
   - Verify proper use of scopes and callbacks

5. **Documentation**
   - Check if docs/ needs updates
   - Verify complex logic has clear method names

Provide detailed feedback with specific file:line_number references.
