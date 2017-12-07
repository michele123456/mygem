class HgThreadPool
    @@instance = nil
    
    def self.instance
        @@instance = HgThreadPool.new if @@instance.nil?
        @@instance
    end

    def free_thread
        @available_threads << HgThread.new
        hg_thread = @available_threads.pop
        @running_threads << hg_thread
        hg_thread
    end

private
    def initialize
        @available_threads =  Queue.new
        @running_threads = Queue.new
    end

end
