require_relative 'vector_and_point'

class Grid
	attr_accessor :pointsArray, :horizontal_amount, :vertical_amount, :show, :size

	def initialize size
		@size = size
		@pointsArray = []
		@show = false
	end

	def calculatePoints
		@pointsArray.clear if @pointsArray.any?
		x = 0
		y = 0
		@horizontal_amount = (800.0 / @size).ceil
		@vertical_amount  = (600.0 / @size).ceil
		addAmountForOutWindowConnecting
		1.upto horizontal_amount do |h|
			y = 0
			1.upto vertical_amount do |v|
				point = Point.new(x, y)
				@pointsArray.push point
				y += @size
			end
		x += @size
        end
	end

	def addAmountForOutWindowConnecting
		@horizontal_amount += 1
		@vertical_amount += 1
	end
end
