# TeXtidote Action [![pre-commit](https://github.com/ChiefGokhlayeh/textidote-action/workflows/pre-commit/badge.svg)](https://github.com/ChiefGokhlayeh/textidote-action/actions?query=workflow%3Apre-commit) [![self-check](https://github.com/ChiefGokhlayeh/textidote-action/workflows/self-check/badge.svg)](https://github.com/ChiefGokhlayeh/textidote-action/actions?query=workflow%3Aself-check)

GitHub Action to lint, spell- and grammar-check LaTeX documents using [TeXtidote](https://github.com/sylvainhalle/textidote).

## Inputs

### `root_file`

**Required** - The root LaTeX file to be linted.

### `working_directory`

**Optional** - Working directory to execute TeXtidote in.

### `report_type`

**Optional** - The type of TeXtidote report to generate (referring to TeXtidote's `--output` option). Default: `html`

### `report_file`

**Optional** - The file path of the TeXtidote report. Default: `report.html`

### `args`

**Optional** - Extra arguments to be passed to TeXtidote.

## Example usage

```yaml
name: Lint LaTeX document
on: [push]
jobs:
    lint_latex:
        runs-on: ubuntu-latest
        steps:
            - name: Set up Git repository
              uses: actions/checkout@v2
            - name: Lint LaTeX document
              uses: ChiefGokhlayeh/textidote-action@v2
              with:
                  root_file: main.tex

                  ## Implied defaults:
                  # working_directory:
                  # report_type: html
                  # report_file: report.html

                  ## Use this setting to pass custom arguments options to
                  ## TeXtidote (such as what grammar checker to use).
                  # args:
            - name: Upload TeXtidote report
              uses: actions/upload-artifact@v2
              with:
                  name: textidote_report
                  path: report.html
```

### Spell Check

The provided Docker image is set up with [`hunspell`](https://github.com/hunspell/hunspell) installed, enabling spell-checking through TeXtidote. To activate it for CI build, set add option `--check <language>` to [`args`](#args), where `<language>` is any language code supported by `hunspell` (examples: `en` - English, `de` - German, `es` - Spanish). Custom dictionaries can be added via option `--dict <path-to-dict-file-in-repo>`.

### More Options

Please refer to the official [TeXtidote readme](https://github.com/sylvainhalle/textidote/blob/master/Readme.md) for more options. Use [`args`](#args) to add custom options.

## Contributing

Please raise an issue if you encounter any issues related to this action. Pull requests are always welcome.

Contributors in alphabetical order:

-   Andreas Baulig

## License

SPDX: [`MIT`](https://opensource.org/licenses/MIT)
