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
  
  def the_block
    @my_block
  end

 
  def wait_for_task_executor
    print 'wait_for_task_executor'<<"\n"
    @hg_task_executor_semaphore.wait
  end

  def wait_for_finish
    @semaphore.wait
  end
end