module Tectogen

  class Pixmap
    attr_reader :width, :height, :pixels

    def initialize(width, height, bg = Color.new(:white))
      @width, @height = width, height
      @pixels = Array.new(height) { Array.new(width, bg.dup) }
    end

    def [](x, y)
      pixels[y][x]
    end

    def []=(x, y, color)
      pixels[y][x] = color if x.between?(0, width - 1) && y.between?(0, height - 1)
    end

    def draw_line(p0, p1, color)
      curr=p0.clone
      dx = (p1.x - p0.x).abs
      dy = (p1.y - p0.y).abs
      sx = curr.x < p1.x ? 1 : -1
      sy = curr.y < p1.y ? 1 : -1
      err = dx - dy

      while true
        self[curr.x, curr.y] = color
        break if curr.x == p1.x && curr.y == p1.y
        e2 = 2 * err
        if e2 > -dy
          err -= dy
          curr.x += sx
        end
        if e2 < dx
          err += dx
          curr.y += sy
        end
      end
    end

    def draw_polyline(points, color)
      points.each_cons(2) do |p0, p1|
        draw_line(p0, p1, color)
      end
    end

    def flood_fill(point, target_color, fill_color)
      return if self[point.x, point.y] != target_color || target_color == fill_color

      queue = [point]
      while (pt = queue.pop)
        cx, cy = pt.to_a
        next unless cx.between?(0,width-1) && cy.between?(0,height-1)
        next unless self[cx, cy] == target_color
        self[cx, cy] = fill_color
        queue << [cx + 1, cy]
        queue << [cx - 1, cy]
        queue << [cx, cy + 1]
        queue << [cx, cy - 1]
      end
    end

    def draw_circle(center, radius, color)
      point=Point.new(radius,0)
      err = 0

      while point.x >= point.y
        set_circle_points(center, point, color)
        point.y += 1
        if err <= 0
          err += 2 * point.y + 1
        else
          point.x -= 1
          err += 2 * (point.y - point.x) + 1
        end
      end
    end

    def fill_circle center,radius,color
      (1..radius).each do |r|
        draw_circle(center,r,color)
      end
    end

    # Méthode privée pour dessiner les 8 octants en symétrie
    def set_circle_points(center, point, color)
      self[center.x + point.x, center.y + point.y] = color
      self[center.x + point.y, center.y + point.x] = color
      self[center.x - point.y, center.y + point.x] = color
      self[center.x - point.x, center.y + point.y] = color
      self[center.x - point.x, center.y - point.y] = color
      self[center.x - point.y, center.y - point.x] = color
      self[center.x + point.y, center.y - point.x] = color
      self[center.x + point.x, center.y - point.y] = color
    end


    def polygone_center(points)
      n = points.size
      raise "At least 3 points are required" if n < 3
      # Assurer que le polygone est fermé
      points << points.first unless points.first == points.last
      aire = 0.0
      cx = 0.0
      cy = 0.0

      (0...points.size - 1).each do |i|
        x0, y0 = points[i].to_a
        x1, y1 = points[i + 1].to_a
        cross = x0 * y1 - x1 * y0
        aire += cross
        cx += (x0 + x1) * cross
        cy += (y0 + y1) * cross
      end

      aire *= 0.5
      if aire == 0.0
        raise "ERROR : degenerated polygon (surface=0)"
      end

      cx /= (6 * aire)
      cy /= (6 * aire)
      Point.new(cx,cy)
    end

    def polycircle_center(circles)
      # circles should be an array of hashes, each representing a circle with :x, :y, and :radius
      # Example: [{x: 0, y: 0, radius: 5}, {x: 3, y: 4, radius: 2}]

      return nil if circles.nil? || circles.empty?

      total_x = 0.0
      total_y = 0.0
      total_weight = 0.0

      circles.each do |circle|
        # The weight could be the area (πr²) or just radius, depending on your needs
        # Using area as weight gives larger circles more influence
        weight = Math::PI * circle.radius**2

        total_x += circle.center.x * weight
        total_y += circle.center.y * weight
        total_weight += weight
      end
      Point.new(total_x / total_weight, total_y / total_weight)
    end

    def save filename
      File.open(filename, 'w') do |file|
        file.puts "P3" # Format PPM texte
        file.puts "#{@width} #{@height}"
        file.puts "255" # Valeur max d'une couleur
        @pixels.each do |row|
          row.each do |color|
            file.print "#{color.r} #{color.g} #{color.b} "
          end
          file.puts
        end
      end
    end
  end
end # module
