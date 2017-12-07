class HgThreadPool
    @@instance = nil

    def self.instance
        @@instance = HgThreadPool.new if @@instance.nil?
        @@instance
    end

    def free_thread

        if @available_threads.count == 0 then
           @available_threads << HgThread.new {|hg_thread| 
           @available_threads << hg_thread
           @running_threads -= 1
           } if total_thread_count < 1  
        end
        
        hg_thread = @available_threads.pop
        @running_threads += 1
        hg_thread
    end

private

    def initialize
        @available_threads =  Queue.new
        @running_threads = 0
    end

    def total_thread_count
	    return @available_threads.count + @running_threads
    end

end
