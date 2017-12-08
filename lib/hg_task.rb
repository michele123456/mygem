class HgTask
  attr_accessor :name
  attr_accessor :semaphore
  attr_accessor :hg_task_executor_semaphore

  def initialize(name=nil, &block)
    @name = name
    @my_block = block if block_given?
    @semaphore = HgSemaphore.new
    @hg_task_executor_semaphore = nil
  end

  def my_block(&block)
    @my_block = block
  end
  
  def my_block
    @my_block
  end

  def hg_task_block(&block)
    @hg_task_block = block
  end
  
  def hg_task_block
    @hg_task_block
  end

  def wait_for_task_executor
    puts 'wait_for_task_executor'
    @hg_task_executor_semaphore.wait
  end

  def wait_for_finish
    @semaphore.wait
  end
end