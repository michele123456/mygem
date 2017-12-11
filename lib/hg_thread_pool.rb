class HgThreadPool
    @@instance = nil

    def self.instance
        @@instance = HgThreadPool.new if @@instance.nil?
        print 'return HgThreadPool instance' <<"\n"
        @@instance
    end

    def free_thread
        begin
            hg_free_thread = nil
            @mutex.synchronize{
                
                print 'free thread entry' <<"\n"
                if @available_threads.empty? then
                    print 'no available thread, spawning one' <<"\n"
                    
                    @available_threads << HgThread.new {|hg_thread| 
                        print 'task finished '<< @mutex.inspect << "\n"
                        
                        @mutex.synchronize{
                            print 'inside hg_thread cleanup synch block'
                            @available_threads << hg_thread
                            @running_threads.delete(hg_thread)
                        }
                            
                    } if total_thread_count < 1  
                end
            
                hg_free_thread = @available_threads.pop
                @running_threads << hg_free_thread if hg_free_thread
                
            }
            
            print 'returning hg_thread '  <<  (hg_free_thread.nil? ? 'nil' : 'not nil')<< "\n"
            return hg_free_thread
        rescue
            print 'free_thread error ' << $!.message<< "\n"
            raise
        end
        
    end

private

    def initialize
        print 'initialize HgThreadPool'<< "\n"
        @available_threads = Array.new
        @running_threads = Array.new
        @mutex = Mutex.new
        print 'HgThreadPool initialized mutex '<< @mutex.inspect<< "\n"
    end

    def total_thread_count
        count_threads = @available_threads.length + @running_threads.length 
        print 'TOTAL_THREAD_count are ' << count_threads.to_s<< "\n"
	    count_threads 
    end

end
