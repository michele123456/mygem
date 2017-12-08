
class HgTaskExecutor
  @@instance = nil

  def self.instance
    @@instance = HgTaskExecutor.new if @@instance.nil?
    @@instance
  end

  #Add the block to the queue and returns that associated task
  def add_task(name=nil,&block)
    puts 'adding new task to executor queue'
    hg_task = HgTask.new(name, &block)
    @tasks_queue << hg_task
    puts 'queue items are ' << @tasks_queue.length.to_s
    
    return hg_task
  end

  def dump_queue
    until @tasks_queue.empty?
      hg_task = @tasks_queue.pop(true) 
      if hg_task
        puts "taks is #{hg_task.name}"
        hg_task.my_block.call if hg_task.my_block
      end
    end
  end

  private

  def initialize
    puts 'initialize singleton'
    @tasks_queue = Queue.new
    @semaphore = HgSemaphore.new
    start_executor_thread
  end

  def start_executor_thread
    Thread.new {
      puts 'start executor thread!!!'
      @semaphore.signal
      while true do
        puts 'waiting for new task'
        hg_task = @tasks_queue.pop
        puts 'new task arrived!!!'
        task_running = run_task(hg_task)
        @tasks_queue << hg_task if !task_running
      end
      puts 'exiting start_executor_thread'
    }
    @semaphore.wait
  end
    
  def run_task(hg_task)
    puts 'running next task'
    free_thread = HgThreadPool.instance.free_thread
    puts 'executing task ' << (hg_task.name.nil? ? '""' : hg_task.name)
    free_thread.execute_task(hg_task) if free_thread
    !free_thread.nil?
  end
end