require './lib/hg_task_executor'
require './lib/hg_task'
require './lib/hg_semaphore'

task_executor = HgTaskExecutor.instance

task = task_executor.add_task {puts 'pippo'}
puts 'waiting...'
task.wait_for_finish
task_executor.add_task('pippo2') {puts 'pippo2'}
task_executor.add_task('pippo3') {puts 'pippo3'}

task_executor.dump_queue