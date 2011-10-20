require 'helper'

require 'kingdom_db'

class KingdomDbTest < Test::Unit::TestCase

  def setup
    @db = KingdomDB.new('localhost', 'root', '', 'kingdom_assignment_taxonomy')
  end

  def test_id_from_taxon_name
    assert_not_nil(@db.id_from_name("Drosophila melanogaster"))
    assert_raise RuntimeError do
      @db.id_from_name("Sarah palin")
    end
    assert_raise RuntimeError do
      @db.id_from_name("")
    end
    assert_raise RuntimeError do
      @db.id_from_name("Shewanella sp")
    end

  end
  def test_name_from_id

    homo =  @db.id_from_name("Homo sapiens")
    assert_equal "Homo sapiens", @db.name_from_id(homo)
    assert_equal "Homo sapiens", @db.name_from_id(homo.to_s)
    assert_equal "Homo sapiens", @db.name_from_id(homo.to_i)

    assert_raise RuntimeError do
      @db.name_from_id(0)
    end
    assert_raise RuntimeError do
      @db.name_from_id(-1)
    end
    assert_raise RuntimeError do
      @db.name_from_id(0)
    end
  end
  def test_parent_id_from_id
    assert_equal "7872", @db.parent_id_from_id("7873")
    assert_equal "7872", @db.parent_id_from_id(7873)
  end
  def test_node_rank_from_id
    assert_equal "species", @db.node_rank_from_id("7873")
    assert_equal "species", @db.node_rank_from_id(7873)
    assert_equal "species", @db.node_rank_from_id(@db.id_from_name("Drosophila melanogaster"))

    assert_equal "genus", @db.node_rank_from_id("7872")
    assert_equal "no rank", @db.node_rank_from_id(1)
    assert_equal "no rank", @db.node_rank_from_id(@db.id_from_name("Woodchuck hepatitis virus 1"))

  end

  def test_name_from_gi
    assert_equal "Oryctolagus cuniculus", @db.name_from_gi(1712)
    assert_equal "Tribolium castaneum", @db.name_from_gi("270016927")
    assert_equal "Clypeaster japonicus", @db.name_from_gi(124106306)
    assert_equal "Anthocidaris crassispina", @db.name_from_gi(124106325)

    assert_equal "Lateolabrax japonicus", @db.name_from_gi(158518390)
    assert_raise RuntimeError do
      @db.name_from_gi(205688854)
    end
    
  end
    
  def test_match_filter
    filter_array = [
                    "Bacteria",
                    "Archaea",
                    "Metazoa",
                    "Viruses"
                   ]
    
    filter_hash = @db.get_filter(filter_array)
    filter_hash.each { |name, id|
      assert_equal @db.id_from_name(name), id
    }
    
    assert_equal ["Bacteria", "Archaea", "Metazoa", "Viruses"], filter_array
    assert_equal "Metazoa", @db.match_filter("Homo sapiens", filter_hash)
    assert_equal "Bacteria", @db.match_filter("Escherichia coli", filter_hash)
    assert_raise RuntimeError do
      assert_equal nil, @db.match_filter("Hello world", filter_hash)
    end
    assert_equal "Bacteria", @db.match_filter("Bacteria", filter_hash)
    assert_equal nil, @db.match_filter("root", filter_hash)
    assert_equal nil, @db.match_filter("Zea mays", filter_hash)
    assert_equal nil, @db.match_filter("cellular organisms", filter_hash)
    
    assert_equal "Bacteria", @db.match_filter("Shewanella sp.", filter_hash)
    assert_raise RuntimeError do
      assert_equal nil, @db.match_filter("Homo s", filter_hash)
    end
    assert_raise RuntimeError do
      assert_equal nil, @db.match_filter("sp", filter_hash)
    end
    assert_equal "Metazoa", @db.match_filter("Homo", filter_hash)

    assert_equal "Viruses", @db.match_filter("Cyanophage Syn26", filter_hash)
    assert_equal "Viruses", @db.match_filter("uncultured phage", filter_hash)
    assert_equal "Bacteria", @db.match_filter("uncultured bacterium", filter_hash)
    assert_equal nil, @db.match_filter("uncultured organism", filter_hash)
    assert_equal "Metazoa", @db.match_filter("Xenopus (Silurana) tropicalis", filter_hash)
    assert_equal "Viruses", @db.match_filter("Pseudomonas phage EL", filter_hash)
    assert_equal "Viruses", @db.match_filter("Pseudomonas phage EL", filter_hash)

    assert_equal "Metazoa", @db.match_filter("Canis lupus familiaris", filter_hash)
    assert_equal "Metazoa", @db.match_filter("Canis familiaris", filter_hash)

    assert_raise RuntimeError do
      @db.match_filter(nil, filter_hash)
    end
        
  end
end
