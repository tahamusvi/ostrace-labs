sudo lttng create stress-matrix-trace



sudo lttng enable-event -k sched_switch,sched_wakeup,sched_wakeup_new,sched_process_fork,sched_process_exit,irq_handler_entry,irq_handler_exit


sudo lttng add-context -k -t vpid -t vtid -t procname -t prio



sudo lttng start
stress-ng --matrix 8 --matrix-size 128 --timeout 10s


sudo lttng stop
sudo lttng destroy




sudo cp -r /root/lttng-traces ~/
sudo chown -R $USER:$USER ~/lttng-traces


tar -czvf matrix-traces.tar.gz ~/lttng-traces


scp fpna@192.168.6.201:~/matrix-traces.tar.gz .