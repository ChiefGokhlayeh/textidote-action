# TeXtidote Action [![self-check](https://github.com/ChiefGokhlayeh/textidote-action/workflows/self-check/badge.svg)](https://github.com/ChiefGokhlayeh/textidote-action/actions?query=workflow%3Aself-check) [![push-image](https://github.com/ChiefGokhlayeh/textidote-action/workflows/push-image/badge.svg)](https://github.com/ChiefGokhlayeh/textidote-action/actions?query=workflow%3Apush-image)

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

## Outputs

### `num_warnings`

Integer value representing the number of warnings TeXtidote found while linting the document. Value is parsed from TeXtidote `stderr`. If parsing fails, [`num_warnings`](#num_warnings) is set to `-1` and an error is logged.

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
              uses: ChiefGokhlayeh/textidote-action@v4
              id: lint
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
            - name: Throw error if linter warnings exist
              if: ${{ steps.lint.outputs.num_warnings != 0 }}
              run: 'echo "::error ${{ steps.lint.inputs.root_file }}::num_warnings: ${{ steps.lint.outputs.num_warnings }}"; exit 1;'
```

### Spell Check

TeXtidote is able to perform spell- and grammar-checking using [Language Tool](https://languagetool.org/). To activate it for CI build, add option `--check <language>` to [`args`](#args), where `<language>` is any language code supported by Language Tool (examples: `en` - English, `de` - German, `es` - Spanish). Custom dictionaries can be added via option `--dict <path-to-dict-file-in-repo>`.

<details><summary>Example: Using English spell check & dictionary</summary>
<p>

```yaml
name: Lint & Spell Check LaTeX document
on: [push]
jobs:
    lint_and_spell_check_latex:
        runs-on: ubuntu-latest
        steps:
            - uses: actions/checkout@v2
            - uses: ChiefGokhlayeh/textidote-action@v4
              with:
                  root_file: main.tex
                  args: --check en --dict en_US.dict
```

</p>
</details>

### More Options

Please refer to the official [TeXtidote readme](https://github.com/sylvainhalle/textidote/blob/master/Readme.md) for more options. Use [`args`](#args) to add custom options.

## Docker Hub

The Docker image created for this action is reusable as a general TeXtidote container and is available on [Docker Hub](https://hub.docker.com/r/gokhlayeh/textidote).

## Contributing

Please raise an issue if you encounter any troubles related to this action. Pull requests are always welcome. This is a hobby project afterall.

Contributors in alphabetical order:

-   Andreas Baulig

## License

SPDX: [`MIT`](https://opensource.org/licenses/MIT)
