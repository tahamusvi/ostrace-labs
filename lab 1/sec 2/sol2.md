تو این تمرین ما یک سناریو مانتورینگ پراسس هارو اجرا کردیم که مراحل رو مرحله به مرحله توضیح میدم

مرحله اول

```shell
sudo lttng create stress-matrix-trace
```

در مرحله اول ما یک سشن برای ضبط اتفاقات با lttng جدید میسازیم.



```shell
sudo lttng enable-event -k sched_switch, sched_wakeup sched_wakeup_new,sched_process_fork, sched_process_exit irq_handler_entry, irq_handler_exit
```

به LTTng می‌گوید چه رویدادهایی را در سطح کرنل (فلگ -k) ثبت کند. اینجا به طور خاص رویدادهای مربوط به زمان‌بند پردازنده (ایجاد، توقف، جابجایی و پایان پردازش‌ها) و وقفه‌های سخت‌افزاری/نرم‌افزاری (irq) را فعال کردیم.


```shell
sudo lttng add-context -k -t vpid -t vtid -t procname -t prio
```
به دیتای بالا اطلاعات بیشتر مثل اهمیت پراسس و اسم پراسس و ایدی پراسس و ایدی ترد اضافه میکنه



# فاز اصلی

```shel

sudo lttng start
stress-ng --matrix 8 --matrix-size 128 --timeout 10s
```

با دستور اول ریکورد شروع میشه
دستور دوم هم استرس ان جی میاد ۸ تا پراسس با تایم اوت ۱۰ ثانیه درست میکنه

حالا ما روی سروره ۲ کور بیشتر نداریم قضیه اینجا قشنگ میشه و نشون میده که هی cpu بین پراسس ها جا به جا میشه تصویر رو میتونیم ببینیم

بعد برای دیدن مثل تصویر دیتارو با دستور های زیر میگیریم و میفرستم رو لپ تاپ خودم و بعد با strace-compas باز میکنیم.


پایان رکورد
```shell
sudo lttng stop
sudo lttng destroy
```

انتقال

```shell
sudo cp -r /root/lttng-traces ~/
sudo chown -R $USER:$USER ~/lttng-traces
tar -czvf matrix-traces.tar.gz ~/lttng-traces
scp fpna@192.168.6.201:~/matrix-traces.tar.gz .
```
