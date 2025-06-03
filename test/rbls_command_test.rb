# frozen_string_literal: true

require 'minitest/autorun'
require 'open3'
require 'tmpdir'

class RblsCommandTest < Minitest::Test
  def test_list_files_in_current_directory
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        # テスト用のファイルを作成
        File.write('file1.txt', 'content1')
        File.write('file2.rb', 'content2')
        Dir.mkdir('subdir')

        # rblsコマンドを実行
        output, status = Open3.capture2(File.expand_path('../bin/rbls', __dir__).to_s)

        assert status.success?, 'rbls command should exit successfully'
        assert_includes output, 'file1.txt'
        assert_includes output, 'file2.rb'
        assert_includes output, 'subdir'
      end
    end
  end

  def test_list_files_in_alphabetical_order
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        # アルファベット順でないファイルを作成
        File.write('zebra.txt', 'content')
        File.write('apple.txt', 'content')
        File.write('banana.rb', 'content')

        output, status = Open3.capture2(File.expand_path('../bin/rbls', __dir__).to_s)

        assert status.success?
        # 出力を行ごとに分割してアルファベット順を確認
        lines = output.strip.split("\n")
        assert_equal ['apple.txt', 'banana.rb', 'zebra.txt'], lines
      end
    end
  end

  def test_show_hidden_files_with_a_option
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        # 隠しファイルと通常ファイルを作成
        File.write('.hidden', 'content')
        File.write('visible.txt', 'content')

        # -aオプション付きで実行
        output_with_a, status = Open3.capture2(File.expand_path('../bin/rbls', __dir__).to_s, '-a')
        assert status.success?

        lines = output_with_a.strip.split("\n")
        assert_includes lines, '.'
        assert_includes lines, '..'
        assert_includes lines, '.hidden'
        assert_includes lines, 'visible.txt'

        # -aオプションなしでは隠しファイルが表示されないことを確認
        output_without_a, status2 = Open3.capture2(File.expand_path('../bin/rbls', __dir__).to_s)
        assert status2.success?

        lines2 = output_without_a.strip.split("\n")
        refute_includes lines2, '.'
        refute_includes lines2, '..'
        refute_includes lines2, '.hidden'
        assert_includes lines2, 'visible.txt'
      end
    end
  end

  def test_reverse_sort_with_r_option
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        # テスト用のファイルを作成
        File.write('alpha.txt', 'content')
        File.write('beta.txt', 'content')
        File.write('gamma.txt', 'content')

        # 通常の場合（アルファベット順）
        output_normal, status = Open3.capture2(File.expand_path('../bin/rbls', __dir__).to_s)
        assert status.success?
        lines_normal = output_normal.strip.split("\n")
        assert_equal ['alpha.txt', 'beta.txt', 'gamma.txt'], lines_normal

        # -rオプション付き（逆順）
        output_reverse, status2 = Open3.capture2(File.expand_path('../bin/rbls', __dir__).to_s, '-r')
        assert status2.success?
        lines_reverse = output_reverse.strip.split("\n")
        assert_equal ['gamma.txt', 'beta.txt', 'alpha.txt'], lines_reverse
      end
    end
  end

  def test_combine_options_a_and_r
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        # 隠しファイルと通常ファイルを作成
        File.write('.alpha', 'content')
        File.write('.beta', 'content')
        File.write('gamma.txt', 'content')
        File.write('delta.txt', 'content')

        # -a -r オプションの組み合わせ（隠しファイルも含めて逆順）
        output, status = Open3.capture2(File.expand_path('../bin/rbls', __dir__).to_s, '-a', '-r')
        assert status.success?

        lines = output.strip.split("\n")
        # 隠しファイルも含まれ、逆順になっていることを確認
        assert_equal ['gamma.txt', 'delta.txt', '.beta', '.alpha', '..', '.'], lines
      end
    end
  end

  def test_combined_options_format
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) do
        File.write('.hidden', 'content')
        File.write('visible.txt', 'content')

        # -ar という連結形式のオプション
        output, status = Open3.capture2(File.expand_path('../bin/rbls', __dir__).to_s, '-ar')
        assert status.success?

        lines = output.strip.split("\n")
        assert_equal ['visible.txt', '.hidden', '..', '.'], lines
      end
    end
  end
end
