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
end
