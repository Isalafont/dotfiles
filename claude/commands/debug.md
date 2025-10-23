# Debug Command

Systematically debug an issue:

1. **Reproduce the Issue**
   - Identify exact steps to reproduce
   - Note expected vs actual behavior
   - Check if it's consistent or intermittent

2. **Gather Information**
   - Review relevant error messages/logs
   - Check recent changes (git log)
   - Identify affected files/components
   - Look for similar issues in codebase

3. **Investigate Root Cause**
   - Use Rails console to test hypotheses
   - Add debug output if needed
   - Check database state
   - Review related tests

4. **Propose Solution**
   - Identify root cause
   - Suggest fix approach
   - Consider edge cases
   - Plan test coverage

5. **Implement Fix**
   - Write failing test first (TDD)
   - Implement fix
   - Verify test passes
   - Run rubocop
   - Run related test suite
   - Write a report of this debug session

Walk through each step systematically.