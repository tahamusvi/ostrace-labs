#!/bin/bash
echo 0 > /sys/kernel/debug/tracing/tracing_on
echo nop > /sys/kernel/debug/tracing/current_tracer

echo function_graph > /sys/kernel/debug/tracing/current_tracer

echo do_mmap > /sys/kernel/debug/tracing/set_graph_function

./lab2 & echo $! > /sys/kernel/debug/tracing/set_ftrace_pid

echo 1 > /sys/kernel/debug/tracing/tracing_on

sleep 3

echo 0 > /sys/kernel/debug/tracing/tracing_on