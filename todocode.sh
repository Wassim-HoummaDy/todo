#!/bin/bash

TODO_FILE="todo_tasks.txt"

load_tasks() {
    if [ -f "$TODO_FILE" ]; then
        cat "$TODO_FILE"
    fi
}

save_tasks() {
    echo "$1" > "$TODO_FILE"
}

create_task() {
    local title description location due_date task_id
    echo "Enter title:"
    read title
    echo "Enter due date (YYYY-MM-DD):"
    read due_date
    echo "Enter description (optional):"
    read description
    echo "Enter location (optional):"
    read location

    if [ -z "$title" ] || [ -z "$due_date" ]; then
        echo "Title and due date are required." >&2
        return
    fi

    local tasks=$(load_tasks)
    local task_id=$(($(echo "$tasks" | wc -l) + 1))
    local task="$task_id|$title|$description|$location|$due_date|0"
    tasks=$(echo -e "$tasks\n$task")

    save_tasks "$tasks"
    echo "Task $task_id created."
}

update_task() {
    local task_id title description location due_date completed
    echo "Enter task ID:"
    read task_id
    echo "Enter title:"
    read title
    echo "Enter due date (YYYY-MM-DD):"
    read due_date
    echo "Enter description (optional):"
    read description
    echo "Enter location (optional):"
    read location
    echo "Is the task completed? (yes/no):"
    read completed
    [ "$completed" == "yes" ] && completed=1 || completed=0

    local tasks=$(load_tasks)
    local updated_tasks=""
    local found=0

    while IFS='|' read -r id t d l dd c; do
        if [ "$id" -eq "$task_id" ]; then
            updated_tasks=$(echo -e "$updated_tasks\n$task_id|$title|$description|$location|$due_date|$completed")
            found=1
        else
            updated_tasks=$(echo -e "$updated_tasks\n$id|$t|$d|$l|$dd|$c")
        fi
    done <<< "$tasks"

    if [ $found -eq 0 ]; then
        echo "Task $task_id not found." >&2
        return
    fi

    save_tasks "$updated_tasks"
    echo "Task $task_id updated."
}

delete_task() {
    local task_id
    echo "Enter task ID:"
    read task_id

    local tasks=$(load_tasks)
    local updated_tasks=""
    local found=0

    while IFS='|' read -r id t d l dd c; do
        if [ "$id" -ne "$task_id" ]; then
            updated_tasks=$(echo -e "$updated_tasks\n$id|$t|$d|$l|$dd|$c")
        else
            found=1
        fi
    done <<< "$tasks"

    if [ $found -eq 0 ]; then
        echo "Task $task_id not found." >&2
        return
    fi

    save_tasks "$updated_tasks"
    echo "Task $task_id deleted."
}

show_task() {
    local task_id
    echo "Enter task ID:"
    read task_id

    local tasks=$(load_tasks)
    local found=0

    while IFS='|' read -r id t d l dd c; do
        if [ "$id" -eq "$task_id" ]; then
            echo "ID: $id"
            echo "Title: $t"
            echo "Description: $d"
            echo "Location: $l"
            echo "Due Date: $dd"
            echo "Completed: $c"
            found=1
        fi
    done <<< "$tasks"

    if [ $found -eq 0 ]; then
        echo "Task $task_id not found." >&2
    fi
}

list_tasks() {
    local date
    echo "Enter date (YYYY-MM-DD):"
    read date

    local tasks=$(load_tasks)
    local completed=""
    local uncompleted=""

    while IFS='|' read -r id t d l dd c; do
        if [ "$dd" == "$date" ]; then
            if [ "$c" -eq 1 ]; then
                completed=$(echo -e "$completed\nID: $id\nTitle: $t\nDescription: $d\nLocation: $l\nDue Date: $dd\nCompleted: $c\n")
            else
                uncompleted=$(echo -e "$uncompleted\nID: $id\nTitle: $t\nDescription: $d\nLocation: $l\nDue Date: $dd\nCompleted: $c\n")
            fi
        fi
    done <<< "$tasks"

    echo "Completed tasks:"
    echo "$completed"
    echo "Uncompleted tasks:"
    echo "$uncompleted"
}

search_tasks() {
    local title
    echo "Enter title:"
    read title

    local tasks=$(load_tasks)
    local found_tasks=""

    while IFS='|' read -r id t d l dd c; do
        if [[ "$t" == *"$title"* ]]; then
            found_tasks=$(echo -e "$found_tasks\nID: $id\nTitle: $t\nDescription: $d\nLocation: $l\nDue Date: $dd\nCompleted: $c\n")
        fi
    done <<< "$tasks"

    echo "Found tasks:"
    echo "$found_tasks"
}

# Main function
main() {
    if [ "$#" -eq 0 ]; then
        local today=$(date +%Y-%m-%d)
        list_tasks "$today"
    else
        local command="$1"
        case "$command" in
            create) create_task ;;
            update) update_task ;;
            delete) delete_task ;;
            show) show_task ;;
            list) list_tasks ;;
            search) search_tasks ;;
            *) echo "Unknown command: $command" >&2 ;;
        esac
    fi
}

main "$@"


