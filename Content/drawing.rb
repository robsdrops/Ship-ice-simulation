require 'gl'
include Gl


class Drawing

	def initialize
		@xc = 0
		@yc = 0
	end

	def drawSea
		glClearColor(0, 0, 1, 0)
		glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT)
		glLoadIdentity
	end

	def drawIcePack ice_pack
		glColor3f(1.0, 1.0, 1.0)
		glBegin(GL_POLYGON)
		ice_pack.vertices.each do |v|
				glVertex2f(v.x, v.y)
			end
		glEnd
	end

    def drawRadius obj
        glColor3f(1.0, 0.0, 0.0)
        glBegin(GL_LINES)
        1.upto(100) do |n|
            theta = (n / 100.0) * 2 * Math::PI
            x = obj.area_size * Math.cos(theta)
            y = obj.area_size * Math.sin(theta)
            glVertex2f(obj.center.x + x, obj.center.y + y)
        end
        glEnd
    end

	def drawGrid grid
		glColor3f(0.5, 0.5, 0.5)
		earlier_point = Point.new(0, 0)
		glBegin(GL_LINES)
			grid.pointsArray.each_with_index do |v, index|
				earlier_point = v if index % (grid.vertical_amount) == 0
				glVertex2f(earlier_point.x, earlier_point.y)
				glVertex2f(v.x, v.y)
				earlier_point = v
			end
		glEnd

		next_point = Point.new(0, 0)

		glBegin(GL_LINES)
			grid.pointsArray.each_with_index do |v, index|
				break if index == calculateIndexForHorizontalDrawing(grid)
				next_point = grid.pointsArray[index + grid.vertical_amount]
				glVertex2f(v.x, v.y)
				glVertex2f(next_point.x, next_point.y)
			end
		glEnd
	end

	def calculateIndexForHorizontalDrawing grid
		grid.vertical_amount * grid.horizontal_amount -  grid.vertical_amount
	end

	def drawShip ship
        glColor3f(1.0, 1.0, 0.0)
        glBegin(GL_POLYGON)
            ship.vertices.each do |v|
            glVertex2f(v.x, v.y)
            end
        glEnd
	end
end
