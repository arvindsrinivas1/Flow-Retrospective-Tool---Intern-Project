class ActionItemsController < ApplicationController

  include UserFindMethods
  before_action :set_action_item, only: [:show, :edit, :update, :destroy]
  before_action :set_user_name
  
  #before_action :get_user

  #before_action :oxford_api_call, :only => [:index]
  # GET /action_items
  # GET /action_items.json




  def index
    @team_name = params[:team_name] 
    session[:team_name] = @team_name unless @team_name.nil?
    @team_id = params[:team_id]
    session[:team_id] = @team_id unless @team_id.nil?

    #get_stanford_response("Dave is lovely.",1000) 

    action_item_arel = ActionItem.arel_table
    @new_items = ActionItem.where({:created_at => Time.zone.now.beginning_of_day..Time.zone.now.end_of_day, :user_id => session[:user_id]})
    @old_items = ActionItem.where((action_item_arel[:created_at].lt(Time.zone.now.beginning_of_day)).and(action_item_arel[:team_id].eq(session[:team_id])))
    @action_item = ActionItem.new
    #@action_items = ActionItem.all
  end

  # GET /action_items/1
  # GET /action_items/1.json
  def show
  end

  # GET /action_items/new
  def new
    @action_item = ActionItem.new
  end

  # GET /action_items/1/edit
  def edit
  end

  # POST /action_items
  # POST /action_items.json
  def create
    api_response = paralleldots_api_call(params[:action_item][:content])    
    #oxford_response = oxford_api_call("mountain")

    api_response_to_save = api_response.select do |key,value|
      [:emotion, :sentiment].include?(key)
    end 

    api_response_to_update = api_response.select do |key,value|
      [:emotion_probabilities, :sentiment_probabilities].include?(key)
    end  
    
    @action_item = ActionItem.new(action_item_params.merge(api_response_to_save)) #To save

    #@action_item.user_id = session[:user_id]
    user = User.find(session[:user_id].to_i)
    team = Team.find(session[:team_id].to_i)

    @action_item.user = user
    @action_item.team = team
    #puts @action_item
    #puts @action_item.inspect
    #update_team_score

    respond_to do |format|
      if @action_item.save()
        format.html { redirect_to action_items_path, notice: 'Action item was successfully created.' }
        format.json { render :show, status: :created, location: @action_item }
      else
        puts @action_item.errors.full_messages
        @error_message = "Action Item not saved"
        format.html { render :create}
        format.json { render json: @action_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /action_items/1
  # PATCH/PUT /action_items/1.json
  def update
    respond_to do |format|
      if @action_item.update(action_item_params)
        format.html { redirect_to @action_item, notice: 'Action item was successfully updated.' }
        format.json { render :show, status: :ok, location: @action_item }
      else
        format.html { render :edit }
        format.json { render json: @action_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /action_items/1
  # DELETE /action_items/1.json
  def destroy
    @action_item.destroy
    respond_to do |format|
      format.html { redirect_to action_items_url, notice: 'Action item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_action_item
      @action_item = ActionItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def action_item_params
      params.require(:action_item).permit(:content, :emotion, :sentiment)
    end

  #All shiz API
  def paralleldots_api_call(content)
    puts "MONEYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY"
    content_ner = ner(content)
    puts content_ner
    content_keyword = keywords(content)
    puts content_keyword
    puts "MONEYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY"
    content_emotion = emotion(content)
    content_sentiment = sentiment(content)

    emotion_probabilities = content_emotion["emotion"]["probabilities"]
    sentiment_probabilities = content_sentiment["probabilities"]
    best_emotion = content_emotion["emotion"]["emotion"] #A list with [sentiment,probability]
    best_sentiment = sentiment_probabilities.max_by{|key,value| value} #Gives the sentiment with max probability

    response = {:emotion => best_emotion, :sentiment => best_sentiment[0], 
      :emotion_probabilities => emotion_probabilities, :sentiment_probabilities => sentiment_probabilities
    }

    response
  end

  def update_team_score
    team = find_team_from_user_info
    team.update_score_and_save
  end  

  def set_user_name
    @host_name = session[:user_name]
  end  



#JUNK -------JUNK-------JUNK----------JUNK--------JUNK----JUNK-------JUNK-------JUNK---------
=begin
  def oxford_api_call(word_id,filter=nil)
    #http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    language = 'en'
    headers = {"app_id" => OXFORD_DICT_APP_ID, "app_key" => OXFORD_DICT_APP_KEY}
    url = OXFORD_API_ENDPOINT + '/entries/' + language + '/' + word_id.downcase
    response = HTTParty.get(url, :headers => headers, :verify => false)
    puts "---------OXFORD RESPONSE----------------------------"
    puts "RESPONSE BODY: #{response.body}"
    puts "RESPONSE CODE: #{response.code}"
    puts "RESPONSE MESSAGE: #{response.message}"
    puts "RESPONSE HEADERS: #{response.headers.inspect}"
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    response
  end    
  
  def pos_tagger(content)
    tagged = tgr.add_tags(content)
    #ADJECTIVES
    adjectives = tgr.get_adjectives(tagged)
    superlative_adjectives = tgr.get_comparative_adjectives(tagged)
    comparative_adjectives = tgr.get_superlative_adjectives(tagged)
    #NOUNS
    proper = tgr.get_proper_nouns(tagged)
    nouns = tgr.get_nouns(tagged)
    noun_phrases = tgr.get_noun_phrases(tagged)
    max_noun_phrase = tgr.get_max_noun_phrases(tagged)
    #ADVERBS
    adverbs = tgr.get_adverbs(tagged)
    
    readable = tgr.get_readable(text)
  end
#JUNK -------JUNK-------JUNK----------JUNK--------JUNK----JUNK-------JUNK-------JUNK---------
=end
end

