# galoy-concourse-shared

Shared CI tasks, pipeline fragments, and GitHub Actions workflows synced across Galoy repositories.

## Usage

Enter the Nix dev shell, then update the Concourse pipeline:

```sh
direnv allow
ci/repipe
```

## Adding a repository

1. Add the repository to `src_repos` in `ci/values.yml`.

```yaml
src_repos:
  bria: ["rust", "docker", "chart"]
  cala: ["rust", "docker"]
```

2. Merge the change and run:

```sh
ci/repipe
```

This creates a `bump-shared-files-in-<repo>` job. When it runs, it opens a PR in the target repository with updated vendored CI files.

Make sure `galoybot` has access to the target repository.

## Shared files

- `shared/actions/*` syncs to `.github/workflows/`
- `shared/ci/**/*` syncs to `ci/vendor/`

## Feature flags

Supported feature flags:

| Feature | Description |
| --- | --- |
| `nodejs` | Node.js CI files |
| `rust` | Rust CI files |
| `docker` | Docker image build CI files |
| `chart` | Helm chart release CI files |

Files without a feature prefix are synced to all configured repositories.
