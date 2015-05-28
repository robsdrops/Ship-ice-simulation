require_relative 'vector_and_point'
require 'gl'
include Gl

class RadiusRange

    def initialize obj1, obj2
        @obj1 = obj1
        @obj2 = obj2
    end

    def checkIfBeyondRadius
        if checkDistance
            return true
        else
            return false
        end
    end

    def checkDistance
        @obj2.vertices.each do |v|
            dist = Math.sqrt((@obj1.center.x - v.x) ** 2 + (@obj1.center.y - v.y) ** 2)
            dist -= @obj1.area_size
            return false if dist < 0
        end
        return true
    end

    def areDifferent?
        @obj1.object_id != @obj2.object_id
    end

end

class Collision

  attr_reader :obj1, :obj2, :axis, :mtd

  def initialize obj1, obj2
    @obj1 = obj1
    @obj2 = obj2
    @axis_array = []
    @axis = Vector.new
  end

  def checkIntersection
    @obj2.calculateCenter

  	if intersect
          @obj2.vertices.each do |v|
            v.x += @mtd.a1
            v.y += @mtd.a2
          end
  	end

  end
	def intersect
    @axis_array.clear

    return false if checkSeparationForObject @obj1
    return false if checkSeparationForObject @obj2

    findMTD

    d = Vector.new
    d.setAttributes(@obj1.center, @obj2.center)
    @mtd.swap
    @mtd.reverse if(@mtd.dotProductVec d) < 0.0
    return true
	end

  def checkSeparationForObject obj
    earlier_point = obj.vertices.last

    obj.vertices.each_with_index do |v, index|
      @axis = Vector.new
      @axis.setAttributes(earlier_point, v)
      @axis.modifyToAxis

      if axisSeparation
        return true
      else
        @axis_array.push @axis
      end
      earlier_point = v
    end

    return false
  end

  def axisSeparation
    @min_max1 = calculateInterval @obj1
    @min_max2 = calculateInterval @obj2
    if @min_max1[0] > @min_max2[1] || @min_max2[0] > @min_max1[1]
      return true
    end
    d0 = @min_max1[1] - @min_max2[0]
    d1 = @min_max2[1] - @min_max1[0]
    depth = (d0 < d1) ? d0 : d1

    axis_length_squared = @axis.dotProductVec @axis
    @axis.a1 *= depth /axis_length_squared
    @axis.a2 *= depth /axis_length_squared
    return false
  end

  def calculateInterval obj
    extremes = [0, 0]
    d = @axis.dotProductPoint obj.vertices[0]
    extremes[0] = extremes[1] = d
    obj.vertices.each do |v|
      d = @axis.dotProductPoint v
      extremes[0] = d if d < extremes[0]
      extremes[1] = d if d > extremes[1]
    end
    return extremes
  end

  def findMTD
    overlap = @axis_array[0].dotProductVec @axis_array[0]
    @mtd = @axis_array[0]

    @axis_array.each do |axis|
      p = axis.dotProductVec axis
      if p < overlap || overlap < 0
        @mtd = axis
        overlap = p
      end
    end
  end
end
