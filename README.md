# PR Auto Classifier

[![GitHub release (latest by date)](https://img.shields.io/github/v/release/raultoto/pr-classifier)](https://github.com/raultoto/pr-classifier/releases)
[![GitHub Marketplace](https://img.shields.io/badge/Marketplace-PR%20Classifier-blue)](https://github.com/marketplace/actions/pr-auto-classifier)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Automatically classify your Pull Requests based on size, file types, and semantic version requirements. This action analyzes your PRs and adds helpful labels and comments to make PR review and management easier.

## Features

- 📏 **Size Classification**: Automatically labels PRs based on the number of changed lines
- 🏷️ **File Type Detection**: Adds labels based on file types modified in the PR
- 📦 **Version Bump Detection**: Determines required version bump (major/minor/patch) based on conventional commits
- 💬 **Automated Comments**: Adds detailed classification information as a PR comment
- 🎨 **Beautiful Labels**: Creates and applies visually distinct labels for different categories

## Usage

Add this workflow to your repository at `.github/workflows/pr-classification.yml`:

```yaml
name: PR Classification
on:
  pull_request:
    types: [opened, synchronize]

permissions:
  pull-requests: write
  contents: read

jobs:
  classify-pr:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
        with:
          fetch-depth: 0
          
      - name: Classify PR
        uses: raultoto/pr_auto_classifier@v1.0.1
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
```

## Configuration

### Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `github-token` | GitHub token for API access | Yes | `${{ github.token }}` |
| `base-ref` | Base reference for the PR | No | `${{ github.base_ref }}` |
| `pr-number` | Pull request number | No | `${{ github.event.pull_request.number }}` |

### Outputs

| Output | Description |
|--------|-------------|
| `size` | Classified size of the PR |
| `types` | Detected file types in the PR |
| `version-bump` | Required version bump (major/minor/patch) |

## Labels

### Size Labels

| Label | Description | Icon |
|-------|-------------|------|
| `size/minimal` | Less than 10 lines | 🟢 |
| `size/small` | 10-49 lines | 🔵 |
| `size/medium` | 50-199 lines | 🟡 |
| `size/large` | 200-499 lines | 🟠 |
| `size/very-large` | 500-999 lines | 🔴 |
| `size/extensive` | 1000+ lines | ⛔ |

### Version Labels

| Label | Description | Icon |
|-------|-------------|------|
| `major` | Breaking changes detected | 🔨 |
| `minor` | New features added | ✨ |
| `patch` | Bug fixes or minor changes | 🐛 |

### File Type Labels

The action automatically detects and creates labels for various file types including:

- 📜 JavaScript/TypeScript
- 🐍 Python
- 💎 Ruby
- 🐘 PHP
- ☕ Java
- 🎯 Kotlin
- 🦅 Swift
- 🐹 Go
- 🦀 Rust
- ⚡ C/C++/C#
- 🌐 HTML/CSS/SCSS
- 💚 Vue.js
- 🗃️ SQL
- 📝 Markdown
- 📋 JSON/YAML
- 🏗️ Terraform
- 🐳 Docker
- 🐚 Shell scripts

## Example Output

When the action runs, it will add a comment to your PR that looks like this:

```markdown
## PR Classification Results

✨ New features added - Minor version bump required

### Details:
- 📏 Size: `size/small`
- 🏷️ Type: `javascript typescript`
- 📦 Version: `minor`

> This classification is based on conventional commits analysis. Please verify it matches your intentions.
```

## Version Bump Detection

The action analyzes commit messages following the [Conventional Commits](https://www.conventionalcommits.org/) specification:

- 🔨 `major`: Commits with breaking changes (contains `BREAKING CHANGE` or `!` after type)
- ✨ `minor`: Commits with new features (starts with `feat:`)
- 🐛 `patch`: All other changes

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

Raul ([@raultoto](https://github.com/raultoto))

## Support

If you are having issues, please let us know by [opening an issue](https://github.com/raultoto/pr-classifier/issues).

## Acknowledgements

- 🙏 Inspired by various PR classification tools and best practices
- 📝 Uses [Conventional Commits](https://www.conventionalcommits.org/) specification
- 🔧 Built with GitHub Actions
