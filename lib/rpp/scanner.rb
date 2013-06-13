module RPP
  class Scanner
    def initialize(io)
      @io = io
    end
    
    def scan
      indent_level = 0
      while (line = @io.gets)
        indent_level -= 2 if indent_level >= 2 && line =~ /\A#{' ' * (indent_level - 2)}>/
        raise "Improper indentation level: #{line}" unless line =~ /\A#{' ' * indent_level}(.*)/
        line = $1.strip
        
        case line
        when /\A<(\w+)(.*)/
          start_block $1, $2.strip
          indent_level += 2
        when ">"
          end_block
        when /\A(\w+) (.*)/
          key_value $1, $2
        else
          data line
        end
      end
    end
    
    def start_block(key, args)
    end
    
    def end_block
    end
    
    def key_value(key, value)
    end
    
    def data(data)
    end
  end
end