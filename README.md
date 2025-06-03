# rbls

**これはcapytanによるClaude Codeのお試し実装です。**

A Ruby implementation of the `ls` command for listing directory contents.

## Prompt

```markdown
あなたは熟練 Ruby エンジニア兼 TDD コーチです。ruby 3.3.x（ruby@latest）を前提に、UNIX の ls コマンド互換の CLI ツールをステップバイステップで実装してください。
以下の開発ポリシーとフローを必ず守ってください。

【前提・出来上がり像】
- ツール名: `rbls`
- bundler で Gemfile を管理し、依存は `minitest`, `rubocop`, `rake` のみ
- オプションは本家 ls を参考に最終的に `-a` `-l` `-r` 程度までは実装する
- macOS/Linux の bash 上で動くことを想定

【開発フロー（必ずこの順序で繰り返す）】
1. **Red**: 取り組む “最小要件” を 1 つ宣言 → 失敗するテストコードを _Minitest_ で提示
2. **Green**: そのテストが通る最小限の実装を提示（必要ならリファクタリング込み）
3. **Refactor**: `rubocop -A .` を実行した想定でoffenseを列挙し、すべて解消した最終コードを提示
4. 各ステップの終了時点で **テスト実行結果（成功/失敗）と RuboCop Offense** の要約を必ず表示
5. rubocopとrspecをpassしたらgit commitしてください。
6. 1 周期が終わったら次の “最小要件” を考え、1から周期を繰り返します。許可はいりません。

【出力フォーマット規約】
- コードは ```ruby ... ``` ブロック、テスト結果/offense は ```text ... ``` ブロック
- 各ステップでファイル構成をツリー表示（例: `ls -la`）
```

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
