
class HgTaskExecutor
  @@instance = nil

  def self.instance
    @@instance = HgTaskExecutor.new if @@instance.nil?
    @@instance
  end

  def add_task(name=nil,&block)
    puts 'adding new task to executor queue'
    hg_task = HgTask.new(name, &block)
    @tasks_queue << hg_task
    puts 'queue items are ' << @tasks_queue.length.to_s
    run_task
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
  end

  def run_task
    puts 'running next task'

  end
end