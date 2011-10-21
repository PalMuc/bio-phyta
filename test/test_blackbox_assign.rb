require 'helper'
require 'tmpdir'

class BlackBoxTest < Test::Unit::TestCase

  ASSIGN_DATADIR = "test/data/assign"
  
  def test_without_parameters
    #This test does not make a whole lot of sense...
    result = %x[bin/phyta-assign]
    expected = "Invalid arguments, see --help for more information."
    assert_equal expected.strip, result.strip
  end
  
  def test_small
    Dir.mktmpdir do |dir|
      res = %x[bin/phyta-assign -i #{ASSIGN_DATADIR}/in_3.xml -o #{dir}/out_3.csv]

      puts res.inspect
      result = File.open("#{dir}/out_3.csv").read
      target = File.open("#{ASSIGN_DATADIR}/target_3.csv").read

      assert_not_nil result
      assert_not_nil target

      assert_equal target, result, "Output of out_3.xml invalid"
    end
  end

  def test_medium
    Dir.mktmpdir do |dir|
      %x[bin/phyta-assign -i #{ASSIGN_DATADIR}/in_medium.xml -o #{dir}/out_medium.csv]
      result = File.open("#{dir}/out_medium.csv").read
      target = File.open("#{ASSIGN_DATADIR}/target_medium.csv").read

      assert_not_nil result
      assert_not_nil target

      assert_block "Output of out_medium.xml invalid." do
        result == target
      end
    end
  end
  
end

