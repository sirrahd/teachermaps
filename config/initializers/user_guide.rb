# This list of tasks is in the order they are presented in a task list
# and the order in which the user is expected to complete them.
# ID is used to identify the task and find its localized string.
# Weight impacts the percent change by completing the task.
# Link is a link to a place where the user can complete the action.

TASKS = {
  confirm_email:
    { weight: 10,
      link: '/settings' },

  cloud_storage:
    { weight: 50,
      link: '/settings' },

  create_map:
    { weight: 80,
      link: '/' }
}
