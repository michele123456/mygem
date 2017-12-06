require './lib/hg_task_executor'
require './lib/hg_task'

task_executor = HgTaskExecutor.instance

task_executor.add_task {puts 'pippo'}
task_executor.add_task('pippo2') {puts 'pippo2'}
task_executor.add_task('pippo3') {puts 'pippo3'}

task_executor.dump_queue