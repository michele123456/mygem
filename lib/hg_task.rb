class HgTask
  attr_accessor :name

  def initialize(name=nil, &block)
    @name = name
    @my_block = block if block_given?
  end

  def my_block(&block)
    @my_block = block
  end
  
  def my_block
    @my_block
  end
end