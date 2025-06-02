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
      ppm_filename=scene.name+".ppm"
      @pixmap.save ppm_filename
      info 1,"generated ppm file : #{ppm_filename}"
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
      circles=vegetation.polycircle.circles
      circles.each do |circle|
        circle.accept(self,vegetation.color)
      end
      polycircle_center=@pixmap.polycircle_center(circles)
      @pixmap.fill_circle polycircle_center,5,RED
    end

    def visitRoad road,args=nil
      info 2,"visiting Road '#{road.name}'"
      #for each pair of points, compute rectangle with road width.
      road.polyline.points.each_cons(2) do |p0,p1|
        pp p0
        pp p1
        points=compute_rectangle(p0,p1,road.width)
        pp points
        ensure_closed_path(points)
        @pixmap.draw_polyline points,BORDER_COLOR
        barycenter=@pixmap.polygone_center(points)
        @pixmap.flood_fill  barycenter,WHITE,road.color
        @pixmap.draw_circle barycenter,5,RED
        @pixmap.flood_fill  barycenter,road.color,RED
      end

    end

    include Math
    def compute_rectangle p0,p1,width
      half_width=width.to_f/2
      if p1.x==p0.x
        p angle=PI/2
      else
        p angle=atan((p1.y-p0.y)/(p1.x-p0.x))
      end
      ax=p0.x-half_width*cos(PI/2-angle)
      ay=p0.y-half_width*sin(PI/2-angle)
      a=Point.new(ax.to_i,ay.to_i)

      bx=p1.x-half_width*cos(PI/2-angle)
      by=p1.y-half_width*sin(PI/2-angle)
      b=Point.new(bx.to_i,by.to_i)

      cx=p1.x+half_width*cos(PI/2-angle)
      cy=p1.y+half_width*sin(PI/2-angle)
      c=Point.new(cx.to_i,cy.to_i)

      dx=p0.x+half_width*cos(PI/2-angle)
      dy=p0.y+half_width*sin(PI/2-angle)
      d=Point.new(dx.to_i,dy.to_i)
      [a,b,c,d]
    end

    def visitWater water,args=nil
      info 2,"visiting Water '#{water.name}'"
      circles=water.polycircle.circles
      circles.each do |circle|
        circle.accept(self,water.color)
      end
      polycircle_center=@pixmap.polycircle_center(circles)
      @pixmap.fill_circle polycircle_center,5,RED
    end

    def visitCircle circle,color
      @pixmap.draw_circle(circle.center,circle.radius,BORDER_COLOR)
      @pixmap.fill_circle circle.center,circle.radius,color
    end

  end
end
