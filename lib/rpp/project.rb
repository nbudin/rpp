require 'rpp/scanner'

module RPP
  class Project
    attr_reader :root
    
    def initialize
      @root = Block.new
    end
    
    def self.load(io)
      project = Project.new
      Reader.new(io, project).scan
      project
    end
    
    class Block < Hash
      attr_accessor :block_key, :block_args
      
      def inspect
        "<#{block_key} block (keys: #{keys.sort.inspect})>"
      end
    end
    
    class Reader < RPP::Scanner
      def initialize(io, project)
        super(io)
        @project = project
        @block_stack = [project.root]
      end
      
      def start_block(key, args)
        block = Block.new
        block.block_key = key
        block.block_args = args
        
        set_value_in_current_block key, block
        @block_stack << block
      end
      
      def key_value(key, value)
        set_value_in_current_block key, value
      end
      
      def end_block
        @block_stack.pop
      end
      
      private
      def current_block
        @block_stack.last
      end
      
      def set_value_in_current_block(key, value)
        case current_block[key]
        when Array
          current_block[key] << value
        when nil
          current_block[key] = value
        else
          current_block[key] = [current_block[key], value]
        end
      end
    end
  end
end