#!/bin/bash

# Function to print the menu
print_menu() {
    echo "Choose an option:"
    echo "1. Simple Program Comparison"
    echo "2. Standard Benchmark Test"
    echo "3. Extreme Benchmark Test"
    echo "4. Exit"
}

# Function to perform simple program comparison
simple_program_comparison() {
    read -p "Enter the first program command: " program1
    read -p "Enter the second program command: " program2

    echo "Running $program1..."
    py-spy record --nonblocking -- $program1 &>/dev/null &
    PID1=$!
    sleep 1

    echo "Running $program2..."
    py-spy record --nonblocking -- $program2 &>/dev/null &
    PID2=$!
    sleep 1

    echo "Comparing $program1 vs $program2..."
    hyperfine --warmup 3 "$program1" "$program2" --export-json comparison_results.json

    echo "Killing Py-Spy processes..."
    kill $PID1 $PID2 &>/dev/null
}

# Function to perform standard benchmark test
standard_benchmark_test() {
    read -p "Enter the program command: " program

    echo "Running benchmark for $program..."
    hyperfine --warmup 3 "$program" --export-json standard_benchmark_results.json
}

# Function to perform extreme benchmark test
extreme_benchmark_test() {
    read -p "Enter the program command: " program

    echo "Running extreme benchmark for $program..."
    hyperfine --warmup 10 --runs 50 "$program" --export-json extreme_benchmark_results.json
}

# Main loop
while true; do
    print_menu
    read -p "Enter your choice: " choice

    case $choice in
        1)
            simple_program_comparison
            ;;
        2)
            standard_benchmark_test
            ;;
        3)
            extreme_benchmark_test
            ;;
        4)
            exit 0
            ;;
        *)
            echo "Invalid choice!"
            ;;
    esac

    echo ""
done
