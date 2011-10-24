class BlastStringParser
  def initialize
    
  end
  #Set up Regexps
  #SPECIES_REGEXP2 = /^.*\[(\w* \w*).*\].*$/ #captures the first two words in square brackets

  SPECIES_REGEXP2 = /^.*\[(.*)\].*$/ #captures everything in square brackets

  SGI_REGEXP = /^gi\|(\d+)\|.*$/
  #QUERY_SEQ_REGEXP = /^([a-zA-Z0-9]+)[_|\s].*$/ #This captures everything up to the 1st underscore
  QUERY_SEQ_REGEXP = /^(\S+)\s.*$/ #This captures everything until the first whitespace (more robust)
  #do not expect whitespace after the last | for robustness, strip later
  SUBJ_ANNOTATION_REGEXP = /(?:.*\|)*(.*)\[.*/ #TODO check if this REGEXP captures the right stuff

  def get_sgi_info(a_hit_id)
    unless SGI_REGEXP.match(a_hit_id)
      raise("Wrong hit id " + a_hit_id)
    else
      return SGI_REGEXP.match(a_hit_id)[1]
    end
  end

  def get_species_name(a_hit_def)
    unless SPECIES_REGEXP2.match(a_hit_def)
      raise "No species info found!"
    else
      return SPECIES_REGEXP2.match(a_hit_def)[1]
    end
  end

  def get_subject_annotation(a_hit_def)
    unless SUBJ_ANNOTATION_REGEXP.match(a_hit_def)
      puts "Can not parse subject annotation " + a_hit_def[0..20] + "...\n"
      return a_hit_def
    else
      return SUBJ_ANNOTATION_REGEXP.match(a_hit_def)[1].strip
    end
  end

  def get_query_seq(a_query)
    unless QUERY_SEQ_REGEXP.match(a_query)
      return a_query
    else
      return QUERY_SEQ_REGEXP.match(a_query)[1]
    end
  end
end
