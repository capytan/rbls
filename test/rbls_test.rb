# frozen_string_literal: true

require 'minitest/autorun'

class RblsTest < Minitest::Test
  def test_rbls_command_exists
    assert File.exist?('bin/rbls'), 'bin/rbls file should exist'
  end

  def test_rbls_command_is_executable
    assert File.executable?('bin/rbls'), 'bin/rbls should be executable'
  end
end
