require "lemmatizer"

module Metric
	protected
	def get_features(responses,action_item_id)
		puts "ENTERRRRRRRRRR"
		puts responses.count
		hypernym_responses = []
		remove_list = ["I", "i", "he", "He", "she", "She", "is", "am", "are", "was", "were", "being", "been"]

		responses.each do |response|
			hypernym_response = {}
			hypernym_response[:h_subj] = []
			hypernym_response[:h_obj] = []
            hypernym_response[:pos] = {}
			hypernym_response[:h_ner] = response[:ner]	
			response[:sub].each do |subb|; hypernym_response[:h_subj] << subb.split('/')[0]; end 
			response[:obj].each do |ob|; hypernym_response[:h_obj] << ob.split('/')[0]; end 
			hypernym_response[:h_subj] = hypernym_response[:h_subj]- remove_list
			hypernym_response[:h_obj] = hypernym_response[:h_obj] - remove_list
			
			response[:pos].keys.each do |pos|
				hypernym_response[:pos]["h_pos_#{pos}".to_sym] = response[:pos][pos] unless pos=='.'
			    hypernym_response[:pos]["h_pos_#{pos}".to_sym] = add_pos_hypernym(hypernym_response[:pos]["h_pos_#{pos}".to_sym],pos) unless pos=="."
                hypernym_response[:pos]["h_pos_#{pos}".to_sym] -= remove_list
			end

			hypernym_response[:h_subj] = add_subj_hypernym(hypernym_response[:h_subj]) - remove_list
			hypernym_response[:h_obj] = add_obj_hypernym(hypernym_response[:h_obj]) - remove_list
            puts "OOOOOOOOOOOOOOOOOOOOOW"
            puts hypernym_response[:h_ner]
			hypernym_response[:h_ner] = add_ner_hypernym(hypernym_response[:h_ner])

			hypernym_responses << hypernym_response		
			#identified_final_reponse = {:id => action_item_id, :hypernym_responses => hypernym_responses}			
		end
			puts "THE ONLY ONE"
			puts identified_final_reponse = {:id => action_item_id, :hypernym_responses => hypernym_responses}
			puts "IS THIS"
			identified_final_reponse = {:id => action_item_id, :hypernym_responses => hypernym_responses}			
	
	end	

#Assisting methods
	def get_hypernyms(word,pos)
		lemmatizer = Lemmatizer.new		
		hypernyms = []
		expanded_hypernym_list = []
		#word = lemmatizer.lemma(word.to_s, pos.to_sym)
		lemma = WordNet::Lemma.find(word.to_s, pos.to_sym)
		if !(lemma.nil?)
			synset = lemma.synsets[0] 
			synset.expanded_hypernyms.each { |d| expanded_hypernym_list << d }
			expanded_hypernym_list.each do |syn|
			  hypernyms.concat((syn.word_counts.keys).select do |key|; (!(hypernyms.include?key));end)
			end
		end	
		hypernyms
    end	

    def add_subj_hypernym(response_list)

    	response_list.uniq! unless response_list.nil?
    	response_list.each do |word|
    		lookup = Dinosaurus.lookup(word)["noun"]
    		if !(lookup.nil?)
    			synonyms = lookup["syn"]
    			response_list = response_list + synonyms
    		end	    		
    		#puts "WIRDDDDDDD< BROTHER #{word}"
    		#response_list = response_list + Dinosaurus.lookup(word)["noun"]["syn"]
    		#response_list = response_list + get_hypernyms(word,"noun")
    	end
    	response_list	
    end

    def add_obj_hypernym(response_list)
    	response_list.uniq! unless response_list.nil?
    	response_list.each do |word|
    		lookup = Dinosaurus.lookup(word)["noun"]
    		if !(lookup.nil?)
    			synonyms = lookup["syn"]
    			response_list = response_list + synonyms
    		end	       		
    		#puts "WIRDDDDDDD< BROTHER #{word}"    
    		#response_list = response_list + Dinosaurus.lookup(word)["noun"]["syn"]    				
    		#response_list = response_list + get_hypernyms(word,"noun")
    	end
    	response_list	
    end

    def add_ner_hypernym(ner)
    	ner.each do |key,values|
    		values.each do |val|
      			lookup = Dinosaurus.lookup(val)["noun"]
      			if !(lookup.nil?)
      				synonyms = lookup["syn"]
                    puts "XXXXXXXXXXXXXXXXXXx"
                    puts synonyms
                    puts "YYYYYYYYYYYYYYYYYY"
      				ner[key] = ner[key] + synonyms
      			end	
    			#ner[key] = ner[key] + Dinosaurus.lookup(word)["noun"]["syn"]
    			#ner[key] = ner[key] + get_hypernyms(val,"noun")
    		end	
    	end	
    	ner
    end   

    def add_pos_hypernym(pos_words,pos)
    	pos_words.uniq! unless pos_words.nil?
    	pos_words.each do |word|
    		#words.uniq! unless words.nil?
    		puts word
    		lookup = Dinosaurus.lookup(word)[pos]
    		if !(lookup.nil?)
    			synonyms = lookup["syn"]
    			pos_words = pos_words + synonyms
    		end	
    		#pos_words = pos_words + get_hypernyms(word,pos.to_s)
    	end
    	pos_words
    end			
end
