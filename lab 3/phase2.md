sudo lttng create deadlock-trace


sudo lttng enable-event -k sched_switch,sched_process_fork,sched_process_exit,sched_wakeup,sched_wakeup_new

sudo lttng enable-event -k --syscall futex

sudo lttng start

sudo lttng start


./deadlock_m


sudo lttng stop
sudo lttng destroy