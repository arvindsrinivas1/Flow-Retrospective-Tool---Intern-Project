class ApplicationController < ActionController::Base	
  protect_from_forgery with: :exception
   

  include Metric
  include Score

  protected

  def get_stanford_response(content,action_item_id)
    response =[]
    content = StanfordCoreNLP::Annotation.new(content)
    StanfordNlpConfig::Setup::StanfordPipeline.annotate(content) 

    content.get(:sentences).each do |sentence|
      sentence_parts_response = {}
      sentence_parts_response[:sub] = []
      sentence_parts_response[:obj] = []
      sentence_parts_response[:ner] = {}
      sentence_parts_response[:pos] = {}

      basic_dependencies = sentence.get(:basic_dependencies).to_s.gsub(/-> /, "")
      dependency_list = basic_dependencies.scan(/\(([^)]+)\)/)
      array_of_words_with_pos = basic_dependencies.to_s.gsub(/\(.*?\)/,"").gsub("\n","").split(" ")
      
      dependency_list.each do |dep|
        if !(dep.to_s =~ /sub/).nil?
          sentence_parts_response[:sub] << array_of_words_with_pos[dependency_list.index(dep)]
        elsif !(dep.to_s =~ /obj/).nil?
          sentence_parts_response[:obj] << array_of_words_with_pos[dependency_list.index(dep)]
        else  
          sentence_parts_response[dep.to_s.gsub(/[\"\[\]]/,"").to_sym] = [] if sentence_parts_response[dep.to_s.gsub(/[\"\[\]]/,"").to_sym].nil?
          sentence_parts_response[dep.to_s.gsub(/[\"\[\]]/,"").to_sym] << array_of_words_with_pos[dependency_list.index(dep)]
        end  
      end

      sentence.get(:tokens).each do |token|
        ner = token.get(:named_entity_tag).to_s.to_sym 
        puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        tok = token.get(:original_text).to_s
        pos = token.get(:part_of_speech).to_s
        if pos[0] == 'N'
          pos = "noun"  
        elsif pos[0] == 'V'
          pos = "verb"
        elsif pos[0] == 'R'
          pos = "adverb"
        elsif pos[0] == 'J'
          pos = "adjective"
        end  
        sentence_parts_response[:pos][pos] ||= [] 
        sentence_parts_response[:pos][pos] << tok  
        puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        if (ner!='O'.to_sym)
          sentence_parts_response[:ner][ner] ||= []
          sentence_parts_response[:ner][ner] << token.get(:original_text).to_s
        end   
      end  
      response << sentence_parts_response
      puts sentence_parts_response[:pos]   
    end
    puts "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM"
    #puts Dinosaurus.lookup('Chicago')
    #puts Dinosaurus.similar_to('bad')
    #get_features(response,action_item_id)    
    r1 = {:id=>999, :hypernym_responses=>[{:h_subj=>["Aravind","river"], :h_obj=>[], :h_ner=>{:PERSON=>["Aravind"],:LOCATION =>["Chicago"]}, :h_pos_noun=>["Aravind"], :h_pos_verb=>["is"], :h_pos_adjective=>["lovely", "adorable", "endearing"]}]}
    r2 = {:id=>1000, :hypernym_responses=>[{:h_subj=>["Dave","river"], :h_obj=>[], :h_ner=>{:PERSON=>["Dave"],:LOCATION =>["Chicago"]}, :h_pos_noun=>["Dave"], :h_pos_verb=>["is"], :h_pos_adjective=>["lovely", "adorable", "endearing"]}]}
    calculate(r1,r2)
    #puts Dinosaurus.synonyms_of('building')        
    puts "NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN"
    #puts response   
  end   
end
