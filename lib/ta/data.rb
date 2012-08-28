module Ta
	class Data

		attr_reader :data, :results
		MOVING_AVERAGES_ARRAY = [:sma, :ema, :wma]
		STOCHASTICS_ARRAY = [:macd, :rsi]
		# Error handling
		class DataException < StandardError
		end

		def initialize parameters
			@data = parameters

			# Check if data usable.
			if @data.nil? || @data.empty?
        raise DataException, "There is no data to work on."
      end
			unless @data.is_a?(Array) or @data.is_a?(Hash)
				raise DataException, "Alien data. Given data must be an array or a hash (got #{@data.class})."
			end
		end

		def calc parameters
			# Check is parameters are usable.
			unless parameters.is_a?(Hash)
				raise DataException, 'Given parameters have to be a hash. FORMAT: .add(:type => :sma, :variables => 12)'
			end

			# If not specified, set default :type to :sma.
			parameters[:type] = :sma if parameters[:type].nil? or parameters[:type].empty?

			# Check which type is it and forward it to the right class.
			case
				when MOVING_AVERAGES_ARRAY.include?(parameters[:type]) then @results = Ta::Moving_average.calculate(@data, parameters)
				when STOCHASTICS_ARRAY.include?(parameters[:type]) then puts "Do something for stochastics."
			else 
				# For some reason it doesn't change in GUI.
				raise DataException, "Invalid indicator type specified (#{parameters[:type]})."
			end
		end

	end
end