module Score
	protected
	#max = 2
	def calculate(response1, response2)
		total_score = 0
		scores = {}
		response1[:hypernym_responses].each do |hypernym_response1|
			response2[:hypernym_responses].each do |hypernym_response2|
				available_features = hypernym_response1.keys & hypernym_response2.keys
				available_features.each do |feature|
					scores[feature] ||= 0

					if feature.to_s == "h_ner"
						temp_score = ner_score_calculate(hypernym_response1[feature], hypernym_response2[feature])
					else
						temp_score = other_scores_calculate(hypernym_response1[feature], hypernym_response2[feature])
					end	
					#scores[feature] = temp_score > scores[feature] ? temp_score : scores[feature]	
					scores[feature] = temp_score + scores[feature]
				end 
			end	
        end
        puts scores
		total_score = scores.values.inject(0) do |memo, value|
			memo + value
		end
		puts "TOTAL SCORE --------------- #{total_score}"    
		total_score    
	end	

	def ner_score_calculate(response1,response2)
		common_ner_keys = (response1.keys & response2.keys)
		common_ner_values_count = 0
		unless common_ner_keys.nil?
			common_ner_keys.each do |key|
				common_ner_values_count += (response1[key.to_sym] & response2[key.to_sym]).count
			end	
		end
		return (common_ner_keys.count + common_ner_values_count)		
	end


	def other_scores_calculate(response1, response2)
		return 0 if (response1.blank? & response2.blank?)
		(response1 & response2).count
	end	

end