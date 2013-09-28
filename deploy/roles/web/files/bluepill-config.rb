# -*- encoding : utf-8 -*-
ENV['RAILS_ENV'] = 'production'

# Whenever this file is updated, make sure to update bluepill-initscript.sh!

Bluepill.application('rletters') do |app|

  app.uid = app.gid = 'rletters_deploy'

  app.process('unicorn') do |proc|
    proc.start_command = 'unicorn -c /opt/bluepill/unicorn.rb -E production -D'
    proc.stop_command = 'kill -QUIT {{PID}}'
    proc.restart_command = 'kill -USR2 {{PID}}'

    proc.pid_file = '/opt/bluepill/unicorn.pid'
    proc.working_dir = '/opt/rletters/root'

    proc.start_grace_time = 60
    proc.stop_grace_time = 60
    proc.restart_grace_time = 180

    proc.monitor_children do |child_process|
      child_process.stop_command = 'kill -QUIT {{PID}}'

      child_process.checks :mem_usage, every: 3.minutes, below: 200.megabytes, times: [3,4], fires: :stop
      child_process.checks :cpu_usage, every: 3.minutes, below: 40, times: [3,4], fires: :stop
    end
  end

  app.process('resque-scheduler') do |proc|
    proc.start_command = 'RAILS_ENV=production bundle exec rake resque:scheduler'
    proc.stop_command = 'kill -QUIT {{PID}}'

    proc.pid_file = '/opt/bluepill/resque-scheduler.pid'
    proc.daemonize = true
    proc.working_dir = '/opt/rletters/root'

    proc.start_grace_time = 60
    proc.stop_grace_time = 60
    proc.restart_grace_time = 60
  end

  app.process('resque-pool') do |proc|
    proc.start_command = 'resque-pool --config /opt/bluepill/resque-pool.yml --daemon --environment production'
    proc.stop_command = 'kill -QUIT {{PID}}'
    proc.restart_command = 'kill -HUP {{PID}}'

    proc.pid_file = '/opt/bluepill/resque-pool.pid'
    proc.working_dir = '/opt/rletters/root'

    proc.start_grace_time = 60
    proc.stop_grace_time = 60
    proc.restart_grace_time = 180
  end

end
