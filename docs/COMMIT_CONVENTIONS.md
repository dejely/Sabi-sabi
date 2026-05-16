# Commit Conventions

This repository uses Husky and Commitlint to enforce conventional commit
messages before a commit is created.

Use this format:

```text
type(scope): subject
```

The scope is optional:

```text
feat: add login form
fix(api): handle missing employee records
docs: update setup instructions
```

Common commit types:

- `feat`: a new feature
- `fix`: a bug fix
- `docs`: documentation-only changes
- `style`: formatting changes that do not affect behavior
- `refactor`: code changes that neither fix a bug nor add a feature
- `test`: adding or updating tests
- `chore`: maintenance tasks

The subject should be short, lowercase, and written in the imperative mood.
