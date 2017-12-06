class HgThreadPool

    def self.instance
        @@instance = HgThreadPool.new if @@instance.nil?
        @@instance
    end

    def get_free_thread
        
    end

private
    def initialize
        @available_threads =  []
        @running_threads = []
    end

end
