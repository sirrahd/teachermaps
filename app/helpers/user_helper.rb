module UserHelper
# The items below are tasks the user must complete to 'progress' in
# their usage of TeacherMaps. These inform the progress bar, task list,
# and to a lesser extent popovers. Each needs an ID (used to associate
# with strings, UI, popovers, etc.), weight (used to determine how big
# the task is relative to others), and a link to where the user can go
# to accomplish the task.

  def show_tasks
  {
    confirm_email:
      { weight: 100,
        link: '/settings' },

    cloud_storage:
      { weight: 100,
        link: '/settings' },

    create_map:
      { weight: 100,
        link: '/' },
  }
  end

  # Checks key indicators for user progress. Define this in conjunction
  # with defining a new task.
  def check_progress
    completed = 0

    # Check confirm_email
    if self.confirmed?
      self.options[:confirm_email] = :complete
    else
      self.options[:confirm_email] = :incomplete
    end

    # Check cloud_storage
    if self.has_google_account? or self.has_drop_box_account?
      self.options[:cloud_storage] = :complete
    else
      self.options[:cloud_storage] = :incomplete
    end

    # Check create_map
    if Map.find_by_user_id(self.id).present?
      self.options[:create_map] = :complete
    else
      self.options[:create_map] = :incomplete
    end

    self.save
  end

  # Returns task info personalized for the user (current status of
  # all tasks and their info, percent complete as an int from 1-100,
  # and the next task).
  def show_progress
    progress = {}
    progress[:next_task] = false
    tasks = {}
    completed = 0
    total = 0

    self.check_progress

    show_tasks.reverse_each do |key, value|
      # Find next_task
      unless self.options[key] == :complete
        progress[:next_task] = key
      end

      # Add tasks to task list with status
      if self.options.has_key?(key)
        tasks[key] = self.options[key]
      else
        tasks[key] = :incomplete
      end

      # Calculate progress
      completed += show_tasks[key][:weight] if self.options[key] == :complete
      total += value[:weight]
    end

    progress[:status] = 100 * completed / total
    progress[:tasks] = tasks

    return progress
  end
end
