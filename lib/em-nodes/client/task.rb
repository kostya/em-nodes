class EM::Nodes::Client
  module TaskFeature

    def on_task(task_id, data)
      # redefine me
      # after task done, should call send_task_result(task_id, result)
    end

    def tasks
      @tasks ||= {}
    end

  private

    def on_task_internal(task_id, data)
      obj = on_task(task_id, data)
      tasks[task_id] = obj
    end

    def send_task_result(task_id, result)
      send_task_result_internal(task_id, result)
      tasks.delete(task_id)
    end
  end
end
