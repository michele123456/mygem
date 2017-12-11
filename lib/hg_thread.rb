class HgThread
    attr_accessor :hg_task
    attr_accessor :thread
    attr_accessor :semaphore
    attr_accessor :mutex

    def initialize(&cleanup_block)
        @hg_task = nil
        @semaphore = HgSemaphore.new
        @mutex = Mutex.new
        print 'HgThread initialize..'
        @thread = Thread.new {
            begin
                print 'New hg_thread initialized'<<"\n"
                sleep 0.1
                @semaphore.signal
          
                while true do
                        print 'wait for job'<<"\n"
                        @semaphore.wait
                        next if @hg_task.nil?
                        print 'executing task ' << @hg_task.name << "\n"
                        @hg_task.the_block.call
                        @hg_task.semaphore.signal
                        cleanup_block.call(self)
                end
            rescue
                print 'ERRRORRRR5 ' << $!.message<<"\n"
                raise
            end
            print 'exiting... hg_thread'<<"\n"
        }
        #print 'waiting for hg_thread initialization ...'<<"\n"
        @semaphore.wait
        print 'hg_thread initialized'<<"\n"
    end

    def execute_task(task)
        print 'execute task on hg_thread' << task.name << "\n"
        @hg_task = task
        @semaphore.signal
    end


end
