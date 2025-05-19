require "sxp"
module Tectogen
  class Parser
    def parse filename
      sxp = SXP.read(File.read(filename))
      name=sxp[1]
      2.times{sxp.shift} #consume tokens
      scene=Scene.new(name)
      while sxp.any?
        item=sxp.shift
        case type=sxp_type(item)
        when :dim
          scene.dim=parse_dim(item)
        when :house
          scene << parse_house(item)
        when :vegetation
          scene << parse_vegetation(item)
        when :road
        when :bank
        else
          raise "PARSE ERROR [scene] : unknown sxp type '#{type}'"
        end
      end
      scene
    end

    def sxp_type sxp
      sxp.first
    end

    def parse_dim sxp
      sxp.shift
      Dim.new(*sxp)
    end

    def parse_house sxp
      house=House.new
      sxp.shift
      house.name=sxp.shift
      while sxp.any?
        item=sxp.shift
        case type=sxp_type(item)
        when :color
          house.color=parse_color(item)
        when :polyline
          house.polyline=parse_polyline(item)
        else
          raise "PARSE ERROR [house] : unknown sxp type '#{type}'"
        end
      end
      house
    end

    def parse_color sxp
      sxp.shift
      Color.new(sxp.shift)
    end

    def parse_polyline sxp
      polyline=Polyline.new
      sxp.shift
      while sxp.any?
        item=sxp.shift
        case type=sxp_type(item)
        when :point
          polyline << parse_point(item)
        else
          raise "PARSE ERROR [house] : unknown sxp type '#{type}'"
        end
      end
      polyline
    end

    def parse_point sxp
      point=Point.new
      sxp.shift
      point.x=sxp.shift.to_i
      point.y=sxp.shift.to_i
      point
    end

    def parse_vegetation sxp
      vege=Vegetation.new
      sxp.shift
      vege.name=sxp.shift
      while sxp.any?
        item=sxp.shift
        case type=sxp_type(item)
        when :color
          vege.color=parse_color(item)
        when :polycircle
          vege.polycircle=parse_polycircle(item)
        else
          raise "PARSE ERROR [vegetation] : unknown sxp type '#{type}'"
        end
      end
      vege
    end

    def parse_polycircle sxp
      polycircle=Polycircle.new
      sxp.shift
      while sxp.any?
        item=sxp.shift
        case type=sxp_type(item)
        when :circle
          polycircle << parse_circle(item)
        else
          raise "PARSE ERROR [polycircle] : unknown sxp type '#{type}'"
        end
      end
      polycircle
    end

    def parse_circle sxp
      circ=Circle.new
      sxp.shift
        while sxp.any?
        item=sxp.shift
        case type=sxp_type(item)
        when :point,:center
          circ.center=parse_point(item)
        when :radius
          circ.radius=parse_radius(item)
        else
          raise "PARSE ERROR [circle] : unknown sxp type '#{type}'"
        end
      end
      circ
    end

    def parse_radius sxp
      sxp.shift
      sxp.shift
    end
  end
end
