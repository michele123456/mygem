class HgThread
    attr_accessor :hg_task
    attr_accessor :thread
    attr_accessor :semaphore
    attr_accessor :mutex

    def initialize(&cleanup_block)
        @hg_task = nil
        @semaphore = HgSemaphore.new
        @mutex = Mutex.new
        puts 'HgThread initialize..'
        @thread = Thread.new {
            begin
                puts 'New hg_thread initialized'
                @semaphore.signal
           
                while true do
                    puts 'wait for job'
                    @semaphore.wait
                    @hg_task.my_block.call if @hg_task
                    cleanup_block.call(self)
                    @hg_task.semaphore.signal
                end
            rescue
                puts 'ERRRORRRR5 ' << $!.message
                puts 'ERRRORRRR5 ' << $!.backtrace
              end
            puts 'exiting... hg_thread'
        }
        puts 'waiting for hg_thread initialization ...'
        @semaphore.wait
        puts 'hg_thread initialized'
    end

    def execute_task(task)
        puts 'execute task on hg_thread'
        @hg_task = task
        @semaphore.signal
    end


end
