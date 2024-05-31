# todo
This is a  todo shell script written in Bash that helps you manage your todo tasks. Each task has a unique identifier, a title, a description, a location, a due date and time, and a completion marker.
The script allow to:
- Create a task: You will be prompted to enter the task details to create a task.
- Update a task: You will be prompted to enter the task ID and the updated details it then update given informations.
- Delete a task: You will be prompted to enter the task ID of the task you want to delete.
- Show all information about a task:You will be prompted to enter the task ID in order to display its informations.
- List tasks of a given day in two output sections: You will be prompted to enter the date it give you all task of this day with their states: completed or uncompleted.
- Search for a task by title:You will be prompted to enter the title.
# Design Choices
-By default: the code list completed and uncompleted tasks of the current day.
- **Data Storage**: The tasks are stored in a text file (`todo_tasks.txt`). Each task is represented as a line in a format in this order: 'ID|Title|Description|Location|Due Date|Completed'.
- **Code functions**: The script is organized into functions that handle loading, saving, creating, updating, deleting, and displaying tasks. The `main` function handles command-line arguments and invokes the appropriate function.
- **Error Handling**: The script checks for the existence of tasks and handles invalid task IDs by printing error messages to standard error if they do not exist.

