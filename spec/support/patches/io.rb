class OutputRecorder
	@@lines = []

	class << self
		def add(line)
			@@lines << line
		end
		def reset
			@@lines = []
		end
		def output
			@@lines
		end
	end
end

module Kernel
	def puts(obj)
		OutputRecorder.add(obj)
	end
end