require './lib/hg_task_executor'
require './lib/hg_task'
require './lib/hg_semaphore'
require './lib/hg_thread'
require './lib/hg_thread_pool'

task_executor = HgTaskExecutor.instance

task = task_executor.add_task {puts 'PIPPO'}
puts 'WAITING...'

task.wait_for_finish

task = task_executor.add_task('pippo2') {puts 'pippo2'}
#sleep 2
task.wait_for_finish
(0..10).each do |i|
    task = task_executor.add_task('PIPPO'<<i.to_s) {puts 'PIPPO'<<i.to_s}
end

task.wait_for_finish
#task_executor.dump_queue