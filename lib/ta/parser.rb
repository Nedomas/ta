module Ta

	class Parser

		# Error handling.
		class ParserException < StandardError
		end

		def self.parse_data parameters
			# Check [0], cause it sends a hash, nested in an array.
			if parameters[0].is_a?(Array)
				# Got data as [1, 2, 3, 4, 5]
				usable_data = []
				usable_data = parameters
			elsif parameters[0].is_a?(Hash)
				# Trust that this data is from securities gem.

				# Traverse an array.
				usable_data = Hash.new
				transposed_hash = Hash.new
				# parameters are {:close => [1, 2, 3], :open => []}
				# Such a hacky way to traverse it.
				# FIXME: Now v.to_f converts date to float, it shouldn't.
				parameters.reverse.inject({}){|a, h| 
				  h.each_pair{|k,v| (a[k] ||= []) << v.to_f}
				  transposed_hash = a
				}
			 	usable_data = transposed_hash
			else
				raise ParserException, "It somehow got #{parameters[0].class}, can't use it."
			end

			return usable_data
		end

	end
end