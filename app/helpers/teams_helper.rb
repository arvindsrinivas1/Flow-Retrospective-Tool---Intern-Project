module TeamsHelper
	def display_suggestions(item)
		display_content = [] 
		scores = item.score.sort_by {|k, v| v }
		puts scores
		scores.each do |score|
			display_content << ActionItem.find(score.keys.first.to_i).content
		end
		puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^6"
		puts display_content
		puts "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^5"
		display_content		
	end	
end
