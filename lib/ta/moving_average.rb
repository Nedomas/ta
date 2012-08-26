module Ta
  #
  # Moving averages
  #
	class Moving_average

		# Error handling
		class Moving_averageException < StandardError
		end

		TYPES_ARRAY = [:sma, :ema]

		def initialize parameters
			validate(parameters)
			# Set default values
			# if parameters[:type].nil? || parameters[:type].empty?
			# 	puts 'empty'
			# end
			# # parameters[:type] = type
			# periods = parameters[:periods]
			# data = parameters[:data]
   		#    puts "For type  with period #{periods} parameters are #{data}, END"
   		#    puts parameters
   		puts parameters
    end

    private

    # Validate input parameters
    def validate parameters

    	unless parameters.is_a?(Hash)
				raise Moving_averageException, 'Given parameters have to be a hash.'
			end

			unless parameters.has_key?(:periods)
				raise Moving_averageException, 'You must specify periods value.'
			end

			unless parameters[:periods].is_a?(Integer)
				raise Moving_averageException, 'Periods value must be an integer.'
			end

    	# If not specified, set default :type to :sma.
    	parameters[:type] = :sma if parameters[:type].nil? or parameters[:type].empty?

    	unless TYPES_ARRAY.include?(parameters[:type])
				raise Moving_averageException, 'Invalid type value specified.'
			end

			unless parameters.has_key?(:data)
				raise Moving_averageException, 'You must give some data to work on.'
			end

			# Data should be {"aapl"=>
  		# [{:date=>"2012-01-04",
  		# 	:open=>"410.00",
  		# 	:high=>"414.68", 
  		# 	:low=>"409.28", 
  		# 	:close=>"413.44", 
  		# 	:volume=>"9286500", 
  		# 	:adj_close=>"411.67"}]}
			unless parameters[:data].is_a?(Array)
				raise Moving_averageException, 'Given data must be an array.'
			end

			unless parameters[:data].length >= parameters[:periods]
				raise Moving_averageException, "Data point length (#{parameters[:data].length}) must be greater or equal to periods value (#{parameters[:periods]})."
			end

    end

	end

end