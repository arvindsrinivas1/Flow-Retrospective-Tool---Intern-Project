module StanfordNlpConfig
	class Setup
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
		StanfordPipeline =  StanfordCoreNLP.load(:tokenize, :ssplit, :pos, :lemma, :parse, :ner, :dcoref, :relation)
	end
end		
