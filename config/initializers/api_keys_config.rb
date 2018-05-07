PARALLEL_DOTS_KEY = Rails.application.secrets.parallel_dots_key
OXFORD_DICT_APP_ID = Rails.application.secrets.oxford_dict_app_id
OXFORD_DICT_APP_KEY = Rails.application.secrets.oxford_dict_app_key
OXFORD_API_ENDPOINT = "https://od-api.oxforddictionaries.com/api/v1"
DINOSAUR_API_KEY = Rails.application.secrets.dinosaur_api_key


#ParallelDots 
set_api_key(PARALLEL_DOTS_KEY)

# http://words.bighugelabs.com/api/2/95de5fc7c10a971e0930d0855072fb7c/word/json 
Dinosaurus.configure do |config|
  config.api_key = DINOSAUR_API_KEY
end

StanfordCoreNLP.use :english
StanfordCoreNLP.model_files = {}
StanfordCoreNLP.default_jars = [
  'joda-time.jar',
  'xom.jar',
  'stanford-corenlp-3.5.0.jar',
  'stanford-corenlp-3.5.0-models.jar',
  'jollyday.jar',
  'bridge.jar'
]