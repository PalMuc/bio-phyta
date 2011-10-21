require 'helper'
require 'tmpdir'

class BlackBoxTest < Test::Unit::TestCase

  SPLIT_DATADIR = "test/data/split"
  
  context "Command line output" do
    should "print default message if run without parameters" do
      result = %x[bin/phyta-split]
      expected = "Invalid arguments, see --help for more information."
      assert_equal expected.strip, result.strip
    end
  end

  context "PhyTA Split" do
    should "put a sequence into clean if one hit is not in the filter" do

      Dir.mktmpdir do |dir|
        %x[bin/phyta-split -i #{SPLIT_DATADIR}/in_okay.csv -c #{dir}/clean_okay.csv -d #{dir}/contaminated_okay.csv]
        clean_result = File.open("#{dir}/clean_okay.csv").read
        contaminated_result = File.open("#{dir}/contaminated_okay.csv").read
        
        clean_target = File.open("#{SPLIT_DATADIR}/clean_okay_target.csv").read
        contaminated_target = File.open("#{SPLIT_DATADIR}/contaminated_okay_target.csv").read

        assert_not_nil clean_result
        assert_not_nil contaminated_result
        assert_not_nil clean_target
        assert_not_nil contaminated_target

        assert_equal clean_target, clean_result, "Clean files differ"
        assert_equal contaminated_target, contaminated_result, "Contaminated files differ"
      end
    end


    should "put a sequence into contaminated if all hits are captured by the filter" do

      Dir.mktmpdir do |dir|
        %x[bin/phyta-split -i #{SPLIT_DATADIR}/in_other.csv -c #{dir}/clean_other.csv -d #{dir}/contaminated_other.csv]
        clean_result = File.open("#{dir}/clean_other.csv").read
        contaminated_result = File.open("#{dir}/contaminated_other.csv").read
        
        clean_target = File.open("#{SPLIT_DATADIR}/clean_other_target.csv").read
        contaminated_target = File.open("#{SPLIT_DATADIR}/contaminated_other_target.csv").read

        assert_not_nil clean_result
        assert_not_nil contaminated_result
        assert_not_nil clean_target
        assert_not_nil contaminated_target

        assert_equal clean_target, clean_result, "Clean files differ"
        assert_equal contaminated_target, contaminated_result, "Contaminated files differ"
      end
    end



    
    should "split the small input file correctly" do

      Dir.mktmpdir do |dir|
        %x[bin/phyta-split -i #{SPLIT_DATADIR}/in_3.csv -c #{dir}/clean_3.csv -d #{dir}/contaminated_3.csv]
        clean_result = File.open("#{dir}/clean_3.csv").read
        contaminated_result = File.open("#{dir}/contaminated_3.csv").read
        
        clean_target = File.open("#{SPLIT_DATADIR}/out_3_target_clean.csv").read
        contaminated_target = File.open("#{SPLIT_DATADIR}/out_3_target_contaminated.csv").read

        #assert_not_nil clean_result
        #assert_not_nil contaminated_result
        #assert_not_nil clean_target
        #assert_not_nil contaminated_target

        #assert_equal clean_target, clean_result, "Clean files differ"
        #assert_equal contaminated_target, contaminated_result, "Contaminated files differ"
      end
    end
  end
  
end

