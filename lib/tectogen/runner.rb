require "optparse"

module Tectogen

  class Runner

    def self.run *arguments
      new.run(arguments)
    end

    def run arguments
      compiler=Compiler.new
      compiler.options = args = parse_options(arguments)
      begin
        if filename=args[:sxp_file]
          ok=compiler.compile(filename)
        else
          raise "need a s-expression file : tectogen [options] <file.sxp>"
        end
        return ok
      rescue Exception => e
        puts e.backtrace
        puts e unless compiler.options[:mute]
        return false
      end
    end

    def header
      puts "Tectogen -- Tectonic utilities (#{VERSION})- (c) JC Le Lann 2025"
    end

    private
    def parse_options(arguments)

      parser = OptionParser.new

      no_arguments=arguments.empty?

      options = {}

      parser.on("-h", "--help", "Show help message") do
        puts parser
        exit(true)
      end

      parser.on("-p", "--parse", "parse only") do
        options[:parse_only]=true
      end
      parser.on("-m", "--mute", "silent mode") do
        options[:mute]=true
      end


      parser.on("-v", "--version", "Show version number") do
        puts VERSION
        exit(true)
      end

      parser.parse!(arguments)

      header unless options[:mute]

      options[:sxp_file]=arguments.shift #the remaining c file

      options
    end
  end
end
