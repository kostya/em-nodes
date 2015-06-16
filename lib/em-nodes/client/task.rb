class EM::Nodes::Client
  module TaskFeature
    def initialize(*args)
      super(*args)
      @mutex = Mutex.new
      @tasks_hash = {}
    end

    def on_task(task_id, data)
      # redefine me
      # after task done, should call send_task_result(task_id, result)
    end

    def tasks
      @tasks_hash.values
    end

    def send_task_result(task_id, result)
      send_task_result_internal(task_id, result)
      @mutex.synchronize { @tasks_hash.delete(task_id) }
    end

  private

    def on_task_internal(task_id, data)
      obj = on_task(task_id, data)
      @mutex.synchronize { @tasks_hash[task_id] = obj }
    end
  end
end
