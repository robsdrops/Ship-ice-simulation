require_relative 'collision'

class SeaObject

    attr_accessor :area_size, :vertices, :x0, :y0, :neighbours, :collision_array

    def initialize area_size, x0, y0
        @area_size = area_size
        @x0 = x0
        @y0 = y0
        @neighbours = []
        @vertices = []
        @collision_array = []
        @center = Point.new(0,0)
    end

    def calculateCenter
        @center.y = @center.x = 0
        @vertices.each do |v|
            @center.x += v.x
            @center.y += v.y
        end
        @center.x /= @vertices.length
        @center.y /= @vertices.length
    end

    def possibleToCollide? obj
        distance_guard = RadiusRange.new self, obj
        if distance_guard.areDifferent?
            if distance_guard.checkIfBeyondRadius
                return false
            else
                return true
            end
        end
    end

    def detectNeighbours ices
        ices.each do |obj2|
            unless obj2 == self
                if possibleToCollide? obj2
                   @neighbours.push obj2 unless isAlreadyNeighbour? obj2
                elsif isAlreadyNeighbour? obj2
                   @neighbours.delete_if {|neigh| neigh == obj2}
                end
            end
       end
    end

    def isAlreadyNeighbour? obj
        @neighbour = @neighbours.select{ |neigh| neigh == obj}
        if @neighbour.empty?
            return false
        else
            return true
        end
    end
end
