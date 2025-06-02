module Tectogen

  class AstNode
    def accept(visitor,args=nil)
       name = self.class.name.split(/::/).last
       visitor.send("visit#{name}".to_sym, self ,args) # Metaprograming !
    end

    def str
      @ppr=PrettyPrinter.new #NIY
      self.accept(@ppr)
    end
  end

  #======= true semantic objects ========
  # - scene
  # - house
  # - vegetation
  #========================================

  #========================================
  # scene has:
  #  - name, dim(w,h)
  #  - semantic items : house,vegetation,roads,river,water
  #========================================
  class Scene < AstNode
    attr_accessor :name,:dim,:items
    def initialize name=nil,dim=nil
      @name,@dim=name,dim
      @items=[]
    end

    def width
      @dim.w
    end

    def height
      @dim.h
    end

    def <<(item)
      @items << item
    end
  end

  class House  < AstNode
    attr_accessor :name,:color,:polyline
    def initialize name=nil,color=nil,polyline=[]
      @name,@color,@polyline=name,color,polyline
    end
  end

  class Vegetation  < AstNode
    attr_accessor :name,:color,:polycircle
    def initialize name=nil,color=nil,polycircle=[]
      @name,@color,@polycircle=name,color,polycircle
    end
  end

  class Road < AstNode
    attr_accessor :name,:width,:color,:polyline
    def initialize name=nil,color=nil,width=nil,polyline=[]
      @name,@color,@width,@polyline=name,color,width,polyline
    end
  end

  class Water < AstNode
    attr_accessor :name,:color,:polycircle
    def initialize name=nil,color=nil,polycircle=[]
      @name,@color,@polycircle=name,color,polycircle
    end
  end
  #============ Helpers =================
  # - dim, color, polyline
  # - circle, polycircle
  #========================================
  class Dim < AstNode
    attr_accessor :w,:h
    def initialize w,h
      @w,@h=w,h
    end
  end

  PREDEFINED_COLORS = {
    :red    => [255,0,0],
    :green  => [0,128,0],
    :blue   => [0,0,255],
    :white  => [255,255,255],
    :white1 => [240,240,240],
    :black  => [0,0,0],
    :green1 => [0,255,50],
    :green2 => [50,205,50],
    :orange => [255,165,0],
    :gray   => [169,169,169],
  }


  class Color
    attr_accessor :value
    attr_accessor :r,:g,:b
    def initialize value=[0,0,0]
      @value=value
      case value
      when String,Symbol
        if rgb=PREDEFINED_COLORS[value.to_sym]
          @r,@g,@b=rgb
        else
          raise "ERROR : color '#{value}' not predefined."
        end
      when Array
        @r,@g,@b=rgb
      else
        raise "ERROR : Color object requires either [r,g,b] or predefined color. Got '#{value}'"
      end
    end

    def ==(other)
      @value==other.value
    end
  end

  BLUE  = Color.new(:blue)
  WHITE = Color.new(:white)
  BLACK = Color.new(:black)
  RED   = Color.new(:red)

  class Polyline < AstNode
    attr_accessor :points
    def initialize points=[]
      @points=points
    end

    def << point
      @points << point
    end
  end

  class Point < AstNode
    attr_accessor :x,:y
    def initialize x=nil,y=nil
      @x,@y=x,y
    end

    def to_s
      "(#{x},#{y})"
    end

    def to_a
      [x,y]
    end
  end

  class Circle  < AstNode
    attr_accessor :center,:radius
    def initialize center=nil,radius=nil
      @center,@radius=center,radius
    end
  end

  class Polycircle < AstNode
    attr_accessor :circles
    def initialize circles=[]
      @circles=circles
    end

    def << circle
      @circles << circle
    end

    def each(&block)
      @circles.each(&block)
    end
  end

end
