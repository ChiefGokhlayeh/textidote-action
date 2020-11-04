# TeXtidote [![gokhlayeh/textidote](https://img.shields.io/badge/Docker%20Hub-gokhlayeh%2Ftextidote-blue)](https://hub.docker.com/r/gokhlayeh/textidote)

Minimal [TeXtidote](https://github.com/sylvainhalle/textidote) image useful to lint and spell- and grammar-check TeX documents. Used in [TeXtidote Action](https://github.com/ChiefGokhlayeh/textidote-action), a GitHub Action used to check your TeX documents the CI/CD way.

You might find this image be generic enough to also be used outside the context of the TeXtidote GitHub Action.

## Usage

```sh
docker run -it -v '/path/to/workspace:/textidote' gokhlayeh/textidote ROOT_FILE WORKING_DIR REPORT_TYPE REPORT_FILE THRESHOLD_ERROR [ARGS...]
```

### `ROOT_FILE`

**Required** - The root LaTeX file to be linted.

### `WORKING_DIR`

**Required** - Working directory inside the container to execute TeXtidote in. Pass empty string if not required, example: `""`.

### `REPORT_TYPE`

**Optional** - The type of TeXtidote report to generate (referring to TeXtidote's --output option). Example: `singleline`, `html`

### `REPORT_FILE`

**Optional** - The file path of TeXtidote report. If omitted or empty, report is printed to tty.

### `THRESHOLD_ERROR`

**Optional** - The threshold for the number of warnings from TeXtidote above which non-zero exit code is returned.

### `ARGS`

**Optional** - Extra arguments to be passed to TeXtidote. Any arguments must be passed in a single block of quotes, example: `'--quiet --check en --dict en.dict'`.

## Examples

Mount directory `$(pwd)/doc/` into container and lint `$(pwd)/doc/main.tex`. Report findings in singleline format.

```sh
docker run -it --rm -v "$(pwd)/doc:/doc" gokhlayeh/textidote "main.tex" "/doc" singleline
```

Write findings in `html` format to `report.html` inside mount directory.

```sh
docker run -it --rm -v "$(pwd)/doc:/doc" gokhlayeh/textidote "main.tex" "/doc" html 'report.html'
```

Use English (`en`) spell-checker.

```sh
docker run -it --rm -v "$(pwd)/doc:/doc" gokhlayeh/textidote "main.tex" "/doc" '' '' '' '--check en'
```

## Tips & Tricks

If you feel limited by the given `entrypoint.sh` syntax, remember that you can overwrite the default entrypoint via `docker run ... --entrypoint ...`.

Inside the container you can execute TeXtidote simply via `/usr/local/bin/textidote`. This is a simple shell script calling the TeXtidote `.jar` located at `/usr/local/share/java/textidote/textidote.jar`.
