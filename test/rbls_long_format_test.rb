# frozen_string_literal: true

require 'minitest/autorun'
require 'open3'
require 'tmpdir'

class RblsLongFormatTest < Minitest::Test
  def test_long_format_with_l_option
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        # テスト用のファイルを作成
        File.write('test.txt', 'hello')
        File.chmod(0o644, 'test.txt')
        Dir.mkdir('testdir')

        # -lオプションで詳細表示
        output, status = Open3.capture2(File.expand_path('../bin/rbls', __dir__).to_s, '-l')
        assert status.success?

        lines = output.strip.split("\n")

        # 各行が詳細フォーマットになっていることを確認
        lines.each do |line|
          # パーミッション、リンク数、所有者、グループ、サイズ、日時、ファイル名が含まれる
          assert_match(/^[d-][rwx-]{9}\s+\d+\s+\S+\s+\S+\s+\d+\s+\S+\s+\d+\s+\d+:\d+\s+\S+/, line)
        end

        # ディレクトリとファイルの識別
        dir_line = lines.find { |l| l.include?('testdir') }
        file_line = lines.find { |l| l.include?('test.txt') }

        assert_match(/^d/, dir_line, 'Directory should start with d')
        assert_match(/^-/, file_line, 'File should start with -')
      end
    end
  end
end
