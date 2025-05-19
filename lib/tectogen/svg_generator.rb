require 'rexml/document'

module Tectogen

  class SVGGenerator
    def initialize(width, height)
      @doc = REXML::Document.new
      # Ajout du namespace SVG
      @svg = @doc.add_element("svg", {
        "width" => width.to_s,
        "height" => height.to_s,
        "xmlns" => "http://www.w3.org/2000/svg",
        "xmlns:xlink" => "http://www.w3.org/1999/xlink"
      })
    end

    def draw_circle(cx, cy, radius, fill_color)
      @svg.add_element("circle", {
        "cx" => cx.to_s,
        "cy" => cy.to_s,
        "r" => radius.to_s,
        "fill" => rgb_to_hex(fill_color) # Conversion RVB => Hexadécimal
      })
    end

    def draw_rectangle(x, y, width, height, fill_color)
      @svg.add_element("rect", {
        "x" => x.to_s,
        "y" => y.to_s,
        "width" => width.to_s,
        "height" => height.to_s,
        "fill" => rgb_to_hex(fill_color)
      })
    end

    def save(filename)
      File.open(filename, "w") do |file|
        @doc.write(file, 2) # Le '2' indente le fichier pour une meilleure lisibilité
      end
    end

    private

    def rgb_to_hex(rgb_array)
      "#%02X%02X%02X" % rgb_array # Convertit [255, 0, 0] en "#FF0000"
    end
  end
end #module
