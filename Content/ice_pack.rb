require_relative 'vector_and_point'
require_relative 'sea_object'

class IcePack < SeaObject

	attr_accessor :area_size, :vertices, :x0, :y0, :center, :collision, :move_vec

	def initialize area_size, x0, y0
		super(area_size, x0, y0)
        @type = getRandomPolyType
				@earlier_pos_a1 = 0
				@earlier_pos_a2 = 0
				@move_vec = Vector.new
        generateVertices
        calculateCenter
				convexArea
	end

    def generateVertices
		r = getRandomIceSize/2
		circleArea r
		@x0 += r + rand(@area_size - 2*r)
		@y0 += r + rand(@area_size - 2*r)
		1.upto @type do |v|
			theta = getRandomAngle
			x = r * Math.cos(theta)
			y = r * Math.sin(theta)
			newPoint = Point.new(@x0+x, @y0+y)
			@vertices.push newPoint
		end
		sortPointsForConvexPolygon
	end

	def	sortPointsForConvexPolygon
		setAndCheckIfMoreExtremes
		splitVerticesArray
		sortLower
		sortUpper
		@vertices.clear
		@vertices.concat @lowerArray
		@vertices.concat @upperArray
	end

	def setAndCheckIfMoreExtremes
		@max_x_vertex = @vertices.max_by { |v| v.x }
		@min_x_vertex = @vertices.min_by { |v| v.x }
		@vertices.each do |v|
			@max_x_vertex = checkVerticalMax v, @max_x_vertex if v.x == @max_x_vertex.x
			@min_x_vertex = checkVerticalMin v, @min_x_vertex if v.x == @min_x_vertex.x
		end
	end

	def checkVerticalMax v1, v2
		if v1.y > v2.y
			return v1
		else
			return v2
		end
	end

	def checkVerticalMin v1, v2
		if v1.y < v2.y
			return v1
		else
			return v2
		end
	end

	def splitVerticesArray
		@lowerArray = [@max_x_vertex]
		@upperArray = [@min_x_vertex]
		@vertices.each do |v|
			next if v == @min_x_vertex || v == @max_x_vertex
			if isVertexBelowLine? @min_x_vertex, @max_x_vertex, v
				@lowerArray.push v
			else
				@upperArray.push v
			end
		end
	end

	def isVertexBelowLine? v1, v2, v3
		a = (v1.y - v2.y)/(v1.x - v2.x)
		b = v2.y
		x = v3.x - v2.x
		a * x + b > v3.y ? true : false
	end

	def sortLower
		@lowerArray.each do |v|
			buffer = @lowerArray.select { |vn| vn.x == v.x}
			
			if buffer.count > 1
				buffer.sort_by { |vb| vb.y }
				buffer = buffer.reverse
				@lowerArray.delete_if { |vl| vl.x == buffer[0].x }
				@lowerArray.concat buffer
			end
		end
		@lowerArray = @lowerArray.sort_by { |v| v.x }
		@lowerArray = @lowerArray.reverse
	end

	def sortUpper
		@upperArray.each do |v|
			buffer = @upperArray.select { |vn| vn.x == v.x}
			if buffer.count > 1
				buffer.sort_by { |vb| vb.y }
				@upperArray.delete_if { |vl| vl.x == buffer[0].x }
				@upperArray.concat buffer
			end
		end
		@upperArray = @upperArray.sort_by { |v| v.x }
	end

	def convexArea
		val1 = 0
		val2 = 0
		@vertices.each_with_index do |v, index|
			if index == (@vertices.length - 1)
				val1 += @vertices[index].x * @vertices[0].y
				val2 += @vertices[index].y * @vertices[0].x
			else
				val1 += @vertices[index].x * @vertices[index + 1].y
				val2 += @vertices[index].y * @vertices[index + 1].x
			end
		end
		@polygon_area = 0.5 * (val2 - val1)
	end

	def circleArea r
		@circle_area = 2 * Math::PI * r * r
	end

	def stopped
		if @move_vec.a1 == @earlier_pos_a1 && @move_vec.a2 == @earlier_pos_a2
			return true
		else
			@earlier_pos_a1 = @move_vec.a1
			@earlier_pos_a2 = @move_vec.a2
			return false
		end
	end

	def lowerMTD
		@move_vec.a1 = (@move_vec.a1 * (1 - @polygon_area/(@circle_area * 10))).round(4)
		@move_vec.a2 = (@move_vec.a2 * (1 - @polygon_area/(@circle_area * 10))).round(4)
	end

	def delayMove
		@vertices.each do |v|
			v.x += @move_vec.a1
			v.y += @move_vec.a2
		end
	end

  def getRandomAngle
		rand * (2*Math::PI)
	end

	def getRandomIceSize
		@area_size/2 + rand(@area_size/2)
	end

	def getRandomPolyType
		5 + rand(10)
	end
end
