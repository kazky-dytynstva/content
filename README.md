# Kazky Content Data

**Current Version: 4**

All data modifications must target `/data/4/` and pass validation before merging.

## Modifying Data (Version 4)

1. Create branch `data_update`
2. Modify data in `/data/4/` (tales/people)
3. **Run validation**: `dart validation/bin/validate_data_4.dart`
4. Fix any validation errors
5. Commit, push, and create PR
6. Merge to `main` after validation passes

## Validation

Before committing changes to version 4:
- Run: `dart validation/bin/validate_data_4.dart`
- Ensure all checks pass (JSON structure, references, images)
- Fix errors before creating PR

