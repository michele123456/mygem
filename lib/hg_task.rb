class HgTask
  attr_accessor :name
  attr_accessor :semaphore

  def initialize(name=nil, &block)
    @name = name
    @my_block = block if block_given?
    @semaphore = HgSemaphore.new
  end

  def my_block(&block)
    @my_block = block
  end
  
  def my_block
    @my_block
  end

  def wait_for_finish
    @semaphore.wait
  end
end