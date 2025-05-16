module Tectogen

  class Scene
    attr_accessor :name,:dim,:items
    def initialize name=nil,dim=nil
      @name,@dim=name,dim
      @items=[]
    end

    def <<(item)
      @items << item
    end
  end

  class Dim
    attr_accessor :w,:h
    def initialize w,h
      @w,@h=w,h
    end
  end

  class Color
    attr_accessor :value
    def initialize value
      @value=value
    end
  end

  class Polyline
    attr_accessor :points
    def initialize points=[]
      @points=points
    end

    def << point
      @points << point
    end
  end

  class Point
    attr_accessor :x,:y
    def initialize x=nil,y=nil
      @x,@y=x,y
    end
  end

  class Circle
    attr_accessor :x,:y,:radius
    def initialize x=nil,y=nil,radius=nil
      @x,@y,@radius=x,y,radius
    end
  end

  class House
    attr_accessor :name,:color,:polyline
    def initialize name=nil,color=nil,polyline=[]
      @name,@color,@polyline=name,color,polyline
    end
  end

  class Vegetation
    attr_accessor :name,:color,:polycircle
    def initialize name=nil,color=nil,polycircle=[]
      @name,@color,@polycircle=name,color,polycircle
    end
  end

  class Polycircle
    attr_accessor :circles
    def initialize circles=[]
      @circles=circles
    end

    def << circle
      @circles << circle
    end
  end

end
