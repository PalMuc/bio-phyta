require 'helper'
require 'tmpdir'

class BlackBoxTest < Test::Unit::TestCase

  SPLIT_DATADIR = "test/data/extract"
  
  context "Command line output" do
    should "print default message if run without parameters" do
      result = %x[bin/phyta-extract]
      expected = "Invalid arguments, see --help for more information."
      assert_equal expected.strip, result.strip
    end
  end
end
