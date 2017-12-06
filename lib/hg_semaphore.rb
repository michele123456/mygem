class HgSemaphore

    def initialize
        @mutex = Mutex.new
        @condition = ConditionVariable.new
    end
    
    def signal
        @mutex.synchronize {
            # Thread has finished using the resource
            @condition.signal
        }
    end

    def wait(timeout=nil)
        @mutex.synchronize {
            # Thread now needs the resource
            @condition.wait(@mutex,timeout)
            # thread can now have the resource
        }
    end
end
