class EM::Nodes::Client
  module TaskFeature

    def on_task(task_id, data)
      # redefine me
      # after task done, should call send_task_result(task_id, result)
    end

  private

    def on_task_internal(task_id, data)
      on_task(task_id, data)
    end

    def send_task_result(task_id, result)
      send_task_result_internal(task_id, result)
    end
  end
end
