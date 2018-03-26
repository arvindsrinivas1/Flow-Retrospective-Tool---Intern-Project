class ActionItemsController < ApplicationController
  before_action :set_action_item, only: [:show, :edit, :update, :destroy]
  before_action :get_user, :only => [:index]
  # GET /action_items
  # GET /action_items.json

  def index    
    #user_id = User.find_by_name(@host_name).id
    action_item_arel = ActionItem.arel_table
    @new_items = ActionItem.where(:created_at => Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
    @old_items = ActionItem.where(action_item_arel[:created_at].lt Time.zone.now.beginning_of_day)
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
    api_response = api_call(params[:action_item][:content])    
    api_response_to_save = api_response.select do |key,value|
      [:emotion, :sentiment].include?(key)
    end 

    api_response_to_update = api_response.select do |key,value|
      [:emotion_probabilities, :sentiment_probabilities].include?(key)
    end  
    

    @action_item = ActionItem.new(action_item_params.merge(api_response_to_save)) #To save
    puts ")))))))))))))))"
    puts @user.inspect
    puts "((((((((((((((("    
    @action_item.user_id = @@user.id
    #puts @action_item
    #puts @action_item.inspect
    #update_team_score

    respond_to do |format|
      if @action_item.save
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
  def api_call(content)
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


  def get_user
    client_ip = request.remote_ip
    ping = `ping -a -n 1 #{client_ip}`
    @host_name = ping[/Pinging (.*?).advisory.com/m,1]
    @@user = User.find_by_name(@host_name)  #will be nil if user not already there, else user object.
    if user_not_in_db?(@@user)
      @@user = User.create({:name => @host_name})  
    end  
    puts @@user.inspect
  end

  def user_not_in_db?(user)
    user.nil?
  end
    
end
