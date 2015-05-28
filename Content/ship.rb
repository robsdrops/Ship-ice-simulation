require_relative 'vector_and_point'
require_relative 'sea_object'

class Ship < SeaObject
    attr_accessor :x0, :y0, :vertices, :center, :collision

    def initialize area_size, x0, y0
        super(area_size, x0, y0)
        generateVertices
        calculateCenter
    end

    def generateVertices
        vertex = Point.new(@x0, @y0)
        @vertices.push vertex

        vertex = Point.new(@x0 + 15, @y0 - 15)
        @vertices.push vertex

        vertex = Point.new(@x0 + 30, @y0 - 20)
        @vertices.push vertex

        vertex = Point.new(@x0 + 70, @y0 - 20)
        @vertices.push vertex

        vertex = Point.new(@x0 + 70, @y0 + 20)
        @vertices.push vertex

        vertex = Point.new(@x0 + 30, @y0 + 20)
        @vertices.push vertex

        vertex = Point.new(@x0 + 15, @y0 + 15)
        @vertices.push vertex
    end

end
