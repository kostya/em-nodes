class EM::Nodes::Client
  module Task
    def on_task_internal(task_id, data)
      on_task(task_id, data)
    end

    def on_task(task_id, data)
      # redefine me
    end

    def send_task_result(task_id, result)
      send_task_result_internal(task_id, result)
    end
  end
end
