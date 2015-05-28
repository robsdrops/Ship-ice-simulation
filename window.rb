require 'gosu'
require 'set'
require_relative 'Content/ice_pack'
require_relative 'Content/grid'
require_relative 'Content/drawing'
require_relative 'Content/vector_and_point'
require_relative 'Content/ship'
require_relative 'Content/collision'

WIDTH = 800
HEIGHT = 600

class GameWindow < Gosu::Window

	def initialize
		super WIDTH, HEIGHT, false
		#@sea_voice = Gosu::Song.new(self,  'Media/ocean.ogg')
		#@sea_voice.play(true)
		@drawing = Drawing.new
		@grid = Grid.new(20)
		@ices = []
		@ices_collision = Set.new
		@move_x = 0
		@move_y = 0
		@ship = Ship.new(35, WIDTH - 100, HEIGHT / 2)
		@font = Gosu::Font.new(self, "Arial", 18)
    @grid.calculatePoints
		generateIcePacks
	end

	def generateIcePacks
        @grid.pointsArray.each_with_index do |v, index|
            unless index % (HEIGHT/@grid.size + 1) &&
                index > ((HEIGHT/@grid.size) * (WIDTH/@grid.size) + HEIGHT/@grid.size + 1)
            @ices.push IcePack.new(30, v.x, v.y) if (v.y == 300)
            end
		end
	end

		def update
		    move_down if button_down? Gosu::KbDown
		    move_up if button_down? Gosu::KbUp
		    move_left if button_down? Gosu::KbLeft
		    move_right if button_down? Gosu::KbRight
		    move
        @ship.detectNeighbours @ices
        @ship.neighbours.each do |i|
            @collision = Collision.new(@ship, i)
            if @collision.checkIntersection

							@collision.mtd.a1 = 2	if @collision.mtd.a1 > 2

							@collision.mtd.a1 = -2	if @collision.mtd.a1 < -2

							@collision.mtd.a2 = -2	if @collision.mtd.a2 < -2

							@collision.mtd.a2 = 2	if @collision.mtd.a2 > 2

							i.move_vec = @collision.mtd
							@ices_collision.add i
						end
        end
        @ship.calculateCenter

        @ices.each do |i|
          i.detectNeighbours @ices
					i.neighbours.each do |n|
							@collision = Collision.new(i, n)
							if @collision.checkIntersection
								@collision.obj1.move_vec = @collision.mtd
								@collision.obj2.move_vec.reverse
								@ices_collision.add @collision.obj1
								@ices_collision.add @collision.obj2
							end
					end
        end

				@ices_collision.each do |i|
					if i.stopped
						@ices_collision.delete i
					else
						i.lowerMTD
						i.delayMove
						i.calculateCenter
					end
				end
    end

	def draw
		@drawing.drawSea

		@ices.each do |i|
			@drawing.drawIcePack i
		end

		@drawing.drawShip @ship

		if @grid.show
			@drawing.drawGrid @grid
      @drawing.drawRadius @ship
			@ices.each { |i| @drawing.drawRadius i }
		end
	end

	def button_down(id)
		if id == Gosu::KbG
			@grid.show = !@grid.show
		end
	end

	def move_right
		@move_x += 1
	end

	def move_left
		@move_x -= 1
	end

	def move_up
		@move_y -= 1
	end

	def move_down
		@move_y += 1
	end

	def move
		@ship.vertices.each do |v|
			v.x += @move_x
            v.y += @move_y
        end
        @ship.x0 += @move_x
        @ship.y0 += @move_y
		@move_x = 0
		@move_y = 0
	end

end

window = GameWindow.new
window.show
