
class HgTaskExecutor
  @@instance = nil

  def self.instance
    @@instance = HgTaskExecutor.new if @@instance.nil?
    @@instance
  end

  #Add the block to the queue and returns that associated task
  def add_task(name=nil,&block)
    begin
      print 'adding new task to executor queue'<<"\n"
      hg_task = HgTask.new(name, &block)
      @tasks_queue << hg_task
      print  'queue items are ' << @tasks_queue.length.to_s<<"\n"
    rescue
      print 'ERRRORRRR2 ' << $!.message<<"\n"
      print 'ERRRORRRR2 ' << $!.backtrace<<"\n"
    end
    
    return hg_task
  end

  
  private

  def initialize
    print 'initialize singleton'<<"\n"
    @tasks_queue = Queue.new
    @semaphore = HgSemaphore.new
    @executor_thread = nil
    start_executor_thread
  end

  def start_executor_thread
    @executor_thread = Thread.new {
      begin
          print 'start executor thread!!!' << "\n"
          @semaphore.signal
          while true do
              print 'waiting for new task' << "\n"
              hg_task = @tasks_queue.pop
              print 'new task arrived!!!' << "\n"
              task_running = run_task(hg_task)
              if !task_running
                sleep 1 
                @tasks_queue << hg_task 
              end
            
          end
          print 'exiting start_executor_thread' << "\n"
      rescue
        print 'ERRRORRRR31 ' << $!.message << "\n"
        print 'ERRRORRRR31 ' << $!.backtrace << "\n"
      end
    }
    @semaphore.wait
  end
    
  def run_task(hg_task)
    print 'running next task' << hg_task.inspect << "\n"
    begin
      free_thread = HgThreadPool.instance.free_thread
      print 'run_task  ' << (hg_task.name.nil? ? '""' : hg_task.name) << "\n"
      free_thread.execute_task(hg_task) if free_thread
    rescue
      print 'ERRRORRRR1 ' << $!.message<<"\n"
      print 'ERRRORRRR1 ' << $!.backtrace<<"\n"
    end
    !free_thread.nil?

  end
end