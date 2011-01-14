require 'albacore/albacoretask'


class OutputBuilder
    include FileUtils
    
    def initialize(dir_to, dir_from)
        @dir_to = dir_to
        @dir_from = dir_from
    end
    
    def dir(dir)
        cp_r "#{@dir_from}/#{dir}", @dir_to
    end
    
    def file(f)
        file(f,f)
    end
    
    def file(f, ft)
    #todo find more elegant way to create base dir if missing for file.
        topath = File.dirname("#{@dir_to}/#{ft}")
        mkdir_p topath unless File.exist? topath
        cp "#{@dir_from}/#{f}", "#{@dir_to}/#{ft}"
    end
    
    def self.output_to(dir_to, dir_from)
        rmtree dir_to
        mkdir dir_to
        yield OutputBuilder.new(dir_to, dir_from)
    end

end

class Output
  include Albacore::Task

  def initialize
    super()
    
    @files = []
    @directories = []
  end
    
  def execute()
    fail_with_message 'No base dir' if @from_dir.nil?
    fail_with_message 'No output dir' if @to_dir.nil?
    
    OutputBuilder.output_to(@to_dir, @from_dir)  do |o|
        @directories.each { |f| o.dir f }
        @files.each { |f| o.file f[0], f[1] }
    end
  end
  
  def file(f, opts={})
    f_to = opts[:as] || f
    @files << [f,f_to]
  end

  
  def dir(d)
    @directories << d
  end
  
  def from(from_dir)
    @from_dir = from_dir
  end

  def to(to_dir)
    @to_dir = to_dir
  end
  
end
