module Tectogen

  class Compiler
    include InfoDisplay
    attr_accessor :options

    def compile filename
      scene=parse(filename)
      ppm=gen_ppm(scene)
    end


    def parse scene_filename
      info 0,"parsing '#{scene_filename}'"
      Parser.new.parse(scene_filename)
    end

    def gen_ppm scene
      info 0,"generating ppm file"
      @generator=PPMGenerator.new
      @generator.generate(scene)
    end
  end
end
