module Tectogen

  class PPMGenerator

    include InfoDisplay

    def generate scene
      scene.accept(self)
    end

    private
    def visitScene scene,args=nil
      info 1,"visiting scene '#{scene.name}'"
      bg_color=Color.new(:white)
      @pixmap=Pixmap.new(scene.width,scene.height,bg_color)
      scene.items.each do |item|
        item.accept(self)
      end
      @pixmap.save scene.name+".ppm"
    end

    BORDER_COLOR=BLACK
    def visitHouse house,args=nil
      info 2,"visiting House '#{house.name}'"
      points=house.polyline.points
      ensure_closed_path(points)
      @pixmap.draw_polyline points,BORDER_COLOR
      barycenter=@pixmap.polygone_center(points)

      @pixmap.flood_fill  barycenter,WHITE,house.color
      @pixmap.draw_circle barycenter,5,RED
      @pixmap.flood_fill  barycenter,house.color,RED
    end

    def ensure_closed_path points
      points << points.first unless points.first == points.last
    end

    def visitVegetation vegetation,args=nil
      info 2,"visiting vegetation '#{vegetation.name}'"
      vegetation.polycircle.each do |circle|
        circle.accept(self,vegetation.color)
      end
      polycircle_center=@pixmap.polycircle_center(vegetation.polycircle.circles)
      @pixmap.fill_circle polycircle_center,5,RED
    end

    def visitCircle circle,color
      @pixmap.draw_circle(circle.center,circle.radius,BORDER_COLOR)
      @pixmap.fill_circle circle.center,circle.radius,color
    end

  end
end
