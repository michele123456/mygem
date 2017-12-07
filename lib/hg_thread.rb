class HgThread
    attr_accessor :hg_task
    attr_accessor :thread
    attr_accessor :semaphore
    attr_accessor :mutex
    
    def initialize
        @hg_task = nil
        @semaphore = HgSemaphore.new
        @mutex = Mutex.new
        #@mutex.synchronize{
            @thread = Thread.new {
                puts 'thread initialized'
                @semaphore.signal
                
                puts 'wait for job'
                @semaphore.wait
                hg_task.my_block.call if hg_task
            }
        #}
        puts 'waitin thread initialization ...'
        @semaphore.wait
        puts 'thread initialized'
    end

    def execute(task)
        @hg_task = task
        puts 'execute task'
        @semaphore.signal
    end

    def start
        self.thread = Thread.new {
            puts 'wait for job'
            @semaphore.wait
            hg_task.my_block.call if hg_task
        }
    end
end