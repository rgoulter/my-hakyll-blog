# List available recipes.
default:
    @just --list

# Lint GitHub Actions workflows.
lint-workflows:
    actionlint
