class Point
    attr_accessor :x, :y

	def initialize x, y
		@x = x
		@y = y
	end
end

class Vector

	attr_accessor :a1, :a2

  def initialize
    @a1 = @a2 = 0
  end

	def setAttributes p1, p2
    @a1 = p2.x - p1.x
		@a2 = p2.y - p1.y
	end

	def modifyToAxis
    swap
    negativeA1
	end

  def negativeA1
    @a1 = -@a1
  end

  def swap
    @a1, @a2 = @a2, @a1
  end

	def dotProductPoint p
		@a2 * p.x + @a1 * p.y
	end

  def dotProductVec vec
    @a2 * vec.a2 + @a1 * vec.a1
  end

  def reverse
    @a1 = -@a1
    @a2 = -@a2
  end

end
