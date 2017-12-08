class HgThreadPool
    @@instance = nil

    def self.instance
        @@instance = HgThreadPool.new if @@instance.nil?
        puts 'return HgThreadPool instance'
        @@instance
    end

    def free_thread
        puts 'free thread entry'
        if @available_threads.empty? then
           puts 'no available thread, spawning one'
           @available_threads << HgThread.new {|hg_thread| 
            puts 'task finished'
            @available_threads << hg_thread
            @running_threads -= 1
           } if total_thread_count < 1  
        end
        
        hg_thread = @available_threads.pop
        @running_threads += 1
        puts 'returning hg_thread '  <<  (hg_thread.nil? ? 'nil' : 'not nil')
        hg_thread
    end

private

    def initialize
        puts 'initialize HgThreadPool'
        @available_threads = Queue.new
        @running_threads = 0
    end

    def total_thread_count
	    return @available_threads.length + @running_threads
    end

end
