module StanfordNlpMethods
  extend ActiveSupport::Concern
  
  included do
    puts "STANFORD MODULE INCLUDED"
  end

  def get_stanford_response(content)
    response =[]
    content = StanfordCoreNLP::Annotation.new(content)
    StanfordNlpConfig::Setup::StanfordPipeline.annotate(content) 
    puts "XXXXXwowowow"
    content.get(:sentences).each do |sentence|
      sentence_parts_response = {}
      sentence_parts_response[:sub] = []
      sentence_parts_response[:obj] = []
      sentence_parts_response[:ner] = {}

      basic_dependencies = sentence.get(:basic_dependencies).to_s.gsub(/-> /, "")
      dependency_list = basic_dependencies.scan(/\(([^)]+)\)/)
      array_of_words_with_pos = basic_dependencies.to_s.gsub(/\(.*?\)/,"").gsub("\n","").split(" ")
      puts "wowowow"
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
        puts token.get(:part_of_speech).to_s
        puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        if (ner!='O'.to_sym)
          sentence_parts_response[:ner][ner] ||= []
          sentence_parts_response[:ner][ner] = token.get(:original_text).to_s
        end   
      end  
      response << sentence_parts_response
      #puts sentence_parts_response   
    end
    puts response   
  end
end