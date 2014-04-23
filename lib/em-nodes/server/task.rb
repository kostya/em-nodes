require 'thread'

class EM::Nodes::Server
  module TaskFeature
    def initialize(*args)
      super(*args)
      @mutex = Mutex.new
      @tasks = {}
      @task_inc = 0
    end

    def task_count
      @mutex.synchronize { @tasks.size }
    end

    def send_task(data)
      task_id = next_task_id
      add_task(task_id, data)
      send_task_internal(task_id, data)
    end

    def on_task_result(res)
      # redefine me
    end

    def on_reschedule_tasks(values)
      # redefine me
    end

    def unbind
      super
      on_reschedule_tasks(@tasks.values)
      @mutex.synchronize { @tasks.clear }
    end

  private

    def on_task_result_internal(task_id, res)
      del_task(task_id)
      on_task_result(res)
    end

    def add_task(task_id, data)
      @mutex.synchronize { @tasks[task_id] = data }
    end

    def del_task(task_id)
      @mutex.synchronize { @tasks.delete(task_id) }
    end

    def next_task_id
      @mutex.synchronize { @task_inc += 1 }
    end

  end
end
