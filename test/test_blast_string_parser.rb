require 'helper'
require 'blast_string_parser'

class BlastStringParserTest < Test::Unit::TestCase
  def test_get_species_info
    bsp = BlastStringParser.new()
    assert_equal "Xenopus (Silurana) tropicalis", bsp.get_species_name("PREDICTED: uncharacterized protein K02A2.6-like [Xenopus (Silurana) tropicalis]")
    assert_equal "Corticium_candelabrum", bsp.get_species_name("CC1c114_molpal [Corticium_candelabrum]")
  end
  def test_get_query_seq
    bsp = BlastStringParser.new()
    assert_equal "Aqu1.200003", bsp.get_query_seq("Aqu1.200003")
    assert_equal "AW3C1", bsp.get_query_seq("AW3C1 [Astrosclera_willeyana]")
    assert_equal "AW3C1_molpal", bsp.get_query_seq("AW3C1_molpal")
    assert_equal "CC1c1_molpal", bsp.get_query_seq("CC1c1_molpal [Corticium_candelabrum]")
    assert_equal "CC1c1_molpal", bsp.get_query_seq("CC1c1_molpal  [Corticium_candelabrum]")
    assert_equal "CC1c1_molpal", bsp.get_query_seq("CC1c1_molpal \n[Corticium_candelabrum]")
    assert_equal "CC1c1_molpal", bsp.get_query_seq("CC1c1_molpal [Corticium_candelabrum], this is a nice_sequence I found rummaging through my fridge [an older model from AEG]")
    assert_equal "CC1c1", bsp.get_query_seq("CC1c1 (tastes really good with curry)")
    assert_equal "CC1c1_molpal", bsp.get_query_seq("CC1c1_molpal [Corticium_candelabrum] (oh, hai!)")
    
  end
end
