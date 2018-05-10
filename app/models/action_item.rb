class ActionItem < ApplicationRecord
  serialize :response, Hash
  serialize :score, Array

  include StanfordNlpMethods
  include Metric
  include Score
  
  before_save :run_similarity
  belongs_to :user
  belongs_to :team
  

  private

  def run_similarity()
    puts "GOAAAKAKA"
    puts self.content
   	get_stanford_response(self.content,self.id)
    puts  "EMENENENEEN"
  end    
end
