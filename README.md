## Contains shared CI tasks synced across repositories.

### Steps for adding in a new repository:

1. Clone and get into the repository:

```
gh repo clone GaloyMoney/concourse-shared
cd concourse-shared
```

2. Edit `ci/values.yml` and under `src_repos`, add the new repository. The key name for the repository must be the name of the repository as on GitHub under GaloyMoney organization.
   This file contains many feature flags according to which the Pull Request will be created with shared tasks.
3. Push the change on the CI.

```
ci/repipe
```

4. Make sure that `galoybot` has permissions to the target repository and it also has `galoybot` as a possible label in the PR.

This would, in turn create a new job under the concourse-shared pipeline and when it runs, it would automatically create the pull request for you on the specified target repository.

### Shared Folder Details (shared/\*\*)

1. `actions` folder - Gets synced to `.github/workflows/` folder
2. `ci/tasks` folder - Get synced to `ci/vendor` folder

### Feature Flags

Feature Flags `nodejs`, `rust`, `chart` and `docker` are supported right now.
Files whose names don't start with them are treated as common and synced to all.

| Feature | Description                                              |
| ------- | -------------------------------------------------------- |
| Nodejs  | Source Codebase is Node.js                               |
| Rust    | Source Codebase is Rust                                  |
| Docker  | Docker image is present in the source                    |
| Chart   | The docker image getting generated also has a Helm Chart |

#### nodejs

- GH Actions:
  - Check Code (`make check-code` after `yarn install`)
  - Audit (`make audit` after `yarn install`)

- Concourse CI:
  - Helpers (`unpack_deps` for caching node_modules)
  - Install Deps (`yarn install`)
  - Check Code (`make check-code`)
  - Audit (`make audit`)

#### rust

- GH Actions:
  - Check Code (`make check-code`)

- Concourse CI:
  - Helpers (Some `CARGO_` envs)
  - Check Code (`make check-code`)

#### docker

- Concorse CI:
  - Prep Docker Build Env

#### chart

- Concourse CI:
  - Open Charts PR
