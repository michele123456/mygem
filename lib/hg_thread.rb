class HgThread
    attr_accessor :hg_task
    attr_accessor :thread
    attr_accessor :semaphore
    attr_accessor :mutex

    def initialize(&cleanup_block)
        @hg_task = nil
        @semaphore = HgSemaphore.new
        @mutex = Mutex.new
        @thread = Thread.new {
            puts 'thread initialized'
            @semaphore.signal
            while true do
                puts 'wait for job'
                @semaphore.wait
                hg_task.my_block.call if hg_task
                cleanup_block.call(hg_task)
            end
        }
        puts 'waiting thread initialization ...'
        @semaphore.wait
        puts 'thread initialized'
    end

    def execute(task)
        @hg_task = task
        puts 'execute task'
        @semaphore.signal
    end


end
