# rbls

A Ruby implementation of the `ls` command for listing directory contents.

## Features

- List files and directories in the current directory
- Alphabetical sorting of entries
- Show hidden files with the `-a` option
- Reverse sort order with the `-r` option

## Installation

Clone the repository and install dependencies:

```bash
git clone <repository-url>
cd rbls
bundle install
```

## Usage

Basic usage - list files in the current directory:
```bash
./bin/rbls
```

Show all files including hidden files:
```bash
./bin/rbls -a
```

Reverse the sort order:
```bash
./bin/rbls -r
```

Combine options:
```bash
./bin/rbls -a -r
```

## Development

Run tests:
```bash
rake test
```

Run linter:
```bash
rubocop
```

## Requirements

- Ruby (version specified in `.ruby-version` if present)
- Bundler

## License

[Specify your license here]