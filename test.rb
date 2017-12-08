require './lib/hg_task_executor'
require './lib/hg_task'
require './lib/hg_semaphore'
require './lib/hg_thread'
require './lib/hg_thread_pool'

begin
task_executor = HgTaskExecutor.instance

task = task_executor.add_task('pluto') {print 'HELLLLLLLLLLLLLLLLLLO PIPPO' << "\n"}
print 'WAITING...'<< "\n"

task.wait_for_finish

task = task_executor.add_task('pippo2') {print 'HELLLLLLLLLLLLLLLLLLO pippo2' << "\n"}
#sleep 2
task.wait_for_finish
(0..10).each do |i|
    task = task_executor.add_task('PIPPO'<<i.to_s) {print 'HELLLLLLLLLLLLLLLLLLO PIPPO'<<i.to_s  << "\n"}
end

task.wait_for_finish

rescue
    print 'ERRRORRRR0 ' << $!.message<< "\n"
    print 'ERRRORRRR0 ' << $!.backtrace<< "\n"
  end
#task_executor.dump_queue