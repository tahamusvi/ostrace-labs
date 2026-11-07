تو این تمرین نحوه فهمیدن اینکه یه برنامه چیکار داره میکنه برا تریسینگ رو تمرین کنیم.


تو مرحله اول ما یه فایل اجرایی داریم که نمیدونیم دقیقا چیکار میکنه.



```shell
sudo perf stat -e 'kmem:*,net:netif*,syscalls:sys_enter_mmap,syscalls:sys_exit_mmap,tcp:*,i2c:*' ./lab2
```

با این دستور میبینیم چه ایونت هایی رخ داده حالا طبق اینا میتونیم یه سری حدس بزنیم.


```
               462      kmem:rss_stat
                 0      kmem:mm_page_alloc_extfrag
                 0      kmem:mm_page_pcpu_drain
                 0      kmem:mm_page_alloc_zone_locked
                37      kmem:mm_page_alloc
                 3      kmem:mm_page_free_batched
                 5      kmem:mm_page_free
                15      kmem:kmem_cache_free
                 8      kmem:kfree
                 2      kmem:kmalloc
               115      kmem:kmem_cache_alloc
                 0      net:netif_receive_skb_list_exit
                 0      net:netif_rx_exit
                 0      net:netif_receive_skb_exit
                 0      net:netif_rx_entry
                 0      net:netif_receive_skb_list_entry
                 0      net:netif_receive_skb_entry
                 0      net:netif_rx
                 0      net:netif_receive_skb
                 9      syscalls:sys_enter_mmap
                 9      syscalls:sys_exit_mmap
                 0      tcp:tcp_cong_state_set
                 0      tcp:tcp_bad_csum
                 0      tcp:tcp_probe
                 0      tcp:tcp_retransmit_synack
                 0      tcp:tcp_rcv_space_adjust
                 0      tcp:tcp_destroy_sock
                 0      tcp:tcp_receive_reset
                 0      tcp:tcp_send_reset
                 0      tcp:tcp_retransmit_skb
                 0      i2c:i2c_result
                 0      i2c:i2c_reply
                 0      i2c:i2c_read
                 0      i2c:i2c_write
```

طبق حالا این خروجی اگه صحبت کنیم مثلا با توجه به اینکه tcp و i2c صفر هستن نتیجه میتونیم بگیریم برنامه کاری به شبکه یا سخت افزار نداره.

چیزی مشخصه از کرنل رم میخواد.


کرنل لینوکس حافظه رو به صورت بلوک‌های ۴ کیلوبایتی به نام Page مدیریت می‌کنه.

من یه مقدار عمیق تر شدم روی اینا مثلا kmem:mm_page_alloc ۳۷ بار رخ داده یعنی 
۳۷ تا پیج گرفته شده

حالا چرا ۳۷ تا این زده ولی ۹ تا اختصاص یعنی mmap داشتیم ؟
چون ممکنه هر mmap میتونه مثلا چندین تا پیج رو بگیره ولی هر کدوم از اون ۳۷ تا یه پیج هستن.


خوده کرنل وقتی نیاز به چند بایت حافظه داره نمیاد یه پیج رو بگیره میاد از کش های خودش استفاده میکنه kmem_cache_alloc 
۱۱۵ بار زده شد 

kmem:kmalloc این هم مثل همونه ولی برای زمانی که تو کش ها با سایز مشخصی حافظه پیدا نشده


kmem_cache_free
kmem:kfree
این دوتا هم برای ازاد کردن همون حافظه های کش هستن


kmem:mm_page_free
kmem:mm_page_free_batched
یه بخشی کوچیکی با این دستورات ازاد شده از حافظه ولی احتمالا بیشترشون بعد اتمام کلی برنامه ازاد میشن



kmem:rss_stat (۴۶۲ بار): مخفف Resident Set Size. هر بار که وضعیت حافظه فیزیکیِ اختصاص‌یافته به برنامه تغییر می‌کنه (مثلاً یه Page جدید میاد تو رم یا خارج میشه)، این رویداد ثبت میشه. عدد بالای ۴۶۲ نشون میده که درگیریِ برنامه با حافظه بسیار پویا بوده و کرنل مدام داشته جدول صفحات (Page Tables) رو آپدیت می‌کرده.
