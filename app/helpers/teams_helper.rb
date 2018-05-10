module TeamsHelper
	def display_suggestions(item)
		scores = item.scores.sort_by {|k, v| v }.reverse
		scores.each do |score|
			puts ActionItem.find(score[0].id).content
			puts ""
		end	
	end	
end
