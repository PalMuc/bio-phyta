require 'helper'
require 'tmpdir'

class BlackBoxTest < Test::Unit::TestCase

  EXTRACT_DATADIR = "test/data/extract"
  EXTRACT_BINARY  = "bin/phyta-extract"
  
  context "Extract command line output" do
    should "print default message if run without parameters" do
      result = %x[#{EXTRACT_BINARY}]
      expected = "Invalid arguments, see --help for more information."
      assert_equal expected.strip, result.strip
    end
  end

  context "Extracting" do
    should "work if the clean file is empty" do
      Dir.mktmpdir do |dir|
        result = %x[#{EXTRACT_BINARY} -c #{EXTRACT_DATADIR}/clean_empty_clean.csv -d #{EXTRACT_DATADIR}/clean_empty_contaminated.csv -f #{EXTRACT_DATADIR}/truncated.fasta -o #{dir}/clean_empty_clean_out.fasta -p #{dir}/clean_empty_contaminated_out.fasta]

        clean_result = File.open("#{dir}/clean_empty_clean_out.fasta").read
        contaminated_result = File.open("#{dir}/clean_empty_contaminated_out.fasta").read
        
        clean_target = File.open("#{EXTRACT_DATADIR}/clean_empty_clean_target.fasta").read
        contaminated_target = File.open("#{EXTRACT_DATADIR}/clean_empty_contaminated_target.fasta").read
        
        assert_not_nil clean_result
        assert_not_nil contaminated_result
        assert_not_nil clean_target
        assert_not_nil contaminated_target

        assert_equal clean_target, clean_result, "Clean files differ"
        assert_equal contaminated_target, contaminated_result, "Contaminated files differ"
      end
    end
    should "work if the contaminated file is empty" do
      Dir.mktmpdir do |dir|
        result = %x[#{EXTRACT_BINARY} -c #{EXTRACT_DATADIR}/contaminated_empty_clean.csv -d #{EXTRACT_DATADIR}/contaminated_empty_contaminated.csv -f #{EXTRACT_DATADIR}/truncated.fasta -o #{dir}/contaminated_empty_clean_out.fasta -p #{dir}/contaminated_empty_contaminated_out.fasta]

        clean_result = File.open("#{dir}/contaminated_empty_clean_out.fasta").read
        contaminated_result = File.open("#{dir}/contaminated_empty_contaminated_out.fasta").read
        
        clean_target = File.open("#{EXTRACT_DATADIR}/contaminated_empty_clean_target.fasta").read
        contaminated_target = File.open("#{EXTRACT_DATADIR}/contaminated_empty_contaminated_target.fasta").read
        
        assert_not_nil clean_result
        assert_not_nil contaminated_result
        assert_not_nil clean_target
        assert_not_nil contaminated_target

        assert_equal clean_target, clean_result, "Clean files differ"
        assert_equal contaminated_target, contaminated_result, "Contaminated files differ"
      end
    end
  end
  
end
