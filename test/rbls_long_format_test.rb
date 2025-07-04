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

  def test_combined_long_format_with_all_files
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        # 隠しファイルと通常ファイルを作成
        File.write('.hidden', 'secret')
        File.write('visible.txt', 'public')

        # -la オプションで隠しファイルも含めた詳細表示
        output, status = Open3.capture2(File.expand_path('../bin/rbls', __dir__).to_s, '-la')
        assert status.success?

        lines = output.strip.split("\n")

        # 隠しファイルも含まれることを確認
        assert(lines.any? { |l| l.include?('.hidden') })
        assert(lines.any? { |l| l.include?('visible.txt') })
        assert(lines.any? { |l| l.include?('.') && l.match(/^d/) }) # . ディレクトリ

        # 各行が詳細フォーマットであることを確認
        lines.each do |line|
          assert_match(/^[d-][rwx-]{9}\s+\d+\s+\S+\s+\S+\s+\d+/, line)
        end
      end
    end
  end

  def test_combined_long_format_with_reverse
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        File.write('alpha.txt', 'a')
        File.write('beta.txt', 'b')

        # -lr オプションで逆順の詳細表示
        output, status = Open3.capture2(File.expand_path('../bin/rbls', __dir__).to_s, '-lr')
        assert status.success?

        lines = output.strip.split("\n")
        filenames = lines.map { |l| l.split.last }

        assert_equal ['beta.txt', 'alpha.txt'], filenames

        # 各行が詳細フォーマットであることを確認
        lines.each do |line|
          assert_match(/^-[rwx-]{9}\s+\d+\s+\S+\s+\S+\s+\d+/, line)
        end
      end
    end
  end
end
