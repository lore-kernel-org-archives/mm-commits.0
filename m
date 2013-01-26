From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-makefile-cleanup.patch added to -mm tree
Date: Fri, 25 Jan 2013 16:47:31 -0800
Message-ID: <20130126004732.1774131C21F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:39961 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab3AZArd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Jan 2013 19:47:33 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so97111qcq.3
        for <mm-commits@vger.kernel.org>; Fri, 25 Jan 2013 16:47:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jg1.han@samsung.com


The patch titled
     Subject: drivers/video/backlight/Makefile: cleanup
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-makefile-cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/video/backlight/Makefile: cleanup

Fix up indenting.  Also alphasort all entries, which reduces patch
collisions.

Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/Makefile |   93 ++++++++++++++---------------
 1 file changed, 47 insertions(+), 46 deletions(-)

diff -puN drivers/video/backlight/Makefile~drivers-video-backlight-makefile-cleanup drivers/video/backlight/Makefile
--- a/drivers/video/backlight/Makefile~drivers-video-backlight-makefile-cleanup
+++ a/drivers/video/backlight/Makefile
@@ -1,50 +1,51 @@
 # Backlight & LCD drivers
 
-obj-$(CONFIG_LCD_CLASS_DEVICE)     += lcd.o
-obj-$(CONFIG_LCD_CORGI)		   += corgi_lcd.o
-obj-$(CONFIG_LCD_HP700)		   += jornada720_lcd.o
-obj-$(CONFIG_LCD_HX8357)	   += hx8357.o
-obj-$(CONFIG_LCD_L4F00242T03)	   += l4f00242t03.o
-obj-$(CONFIG_LCD_LMS283GF05)	   += lms283gf05.o
-obj-$(CONFIG_LCD_LTV350QV)	   += ltv350qv.o
-obj-$(CONFIG_LCD_ILI9320)	   += ili9320.o
-obj-$(CONFIG_LCD_PLATFORM)	   += platform_lcd.o
-obj-$(CONFIG_LCD_VGG2432A4)	   += vgg2432a4.o
-obj-$(CONFIG_LCD_TDO24M)	   += tdo24m.o
-obj-$(CONFIG_LCD_TOSA)		   += tosa_lcd.o
-obj-$(CONFIG_LCD_S6E63M0)	+= s6e63m0.o
-obj-$(CONFIG_LCD_LD9040)	+= ld9040.o
-obj-$(CONFIG_LCD_AMS369FG06)	+= ams369fg06.o
-obj-$(CONFIG_LCD_LMS501KF03)	+= lms501kf03.o
+obj-$(CONFIG_LCD_AMS369FG06)		+= ams369fg06.o
+obj-$(CONFIG_LCD_CLASS_DEVICE)		+= lcd.o
+obj-$(CONFIG_LCD_CORGI)			+= corgi_lcd.o
+obj-$(CONFIG_LCD_HP700)			+= jornada720_lcd.o
+obj-$(CONFIG_LCD_HX8357)		+= hx8357.o
+obj-$(CONFIG_LCD_ILI9320)		+= ili9320.o
+obj-$(CONFIG_LCD_L4F00242T03)		+= l4f00242t03.o
+obj-$(CONFIG_LCD_LD9040)		+= ld9040.o
+obj-$(CONFIG_LCD_LMS283GF05)		+= lms283gf05.o
+obj-$(CONFIG_LCD_LMS501KF03)		+= lms501kf03.o
+obj-$(CONFIG_LCD_LTV350QV)		+= ltv350qv.o
+obj-$(CONFIG_LCD_PLATFORM)		+= platform_lcd.o
+obj-$(CONFIG_LCD_S6E63M0)		+= s6e63m0.o
+obj-$(CONFIG_LCD_TDO24M)		+= tdo24m.o
+obj-$(CONFIG_LCD_TOSA)			+= tosa_lcd.o
+obj-$(CONFIG_LCD_VGG2432A4)		+= vgg2432a4.o
 
-obj-$(CONFIG_BACKLIGHT_CLASS_DEVICE) += backlight.o
-obj-$(CONFIG_BACKLIGHT_ATMEL_PWM)    += atmel-pwm-bl.o
-obj-$(CONFIG_BACKLIGHT_EP93XX)	+= ep93xx_bl.o
-obj-$(CONFIG_BACKLIGHT_GENERIC)	+= generic_bl.o
-obj-$(CONFIG_BACKLIGHT_HP700)	+= jornada720_bl.o
-obj-$(CONFIG_BACKLIGHT_HP680)	+= hp680_bl.o
-obj-$(CONFIG_BACKLIGHT_LM3533)	+= lm3533_bl.o
-obj-$(CONFIG_BACKLIGHT_LOCOMO)	+= locomolcd.o
-obj-$(CONFIG_BACKLIGHT_LM3630)	+= lm3630_bl.o
-obj-$(CONFIG_BACKLIGHT_LM3639)	+= lm3639_bl.o
-obj-$(CONFIG_BACKLIGHT_LP855X)	+= lp855x_bl.o
-obj-$(CONFIG_BACKLIGHT_LP8788)	+= lp8788_bl.o
-obj-$(CONFIG_BACKLIGHT_OMAP1)	+= omap1_bl.o
-obj-$(CONFIG_BACKLIGHT_PANDORA)	+= pandora_bl.o
-obj-$(CONFIG_BACKLIGHT_CARILLO_RANCH) += cr_bllcd.o
-obj-$(CONFIG_BACKLIGHT_PWM)	+= pwm_bl.o
-obj-$(CONFIG_BACKLIGHT_DA903X)	+= da903x_bl.o
-obj-$(CONFIG_BACKLIGHT_DA9052)	+= da9052_bl.o
-obj-$(CONFIG_BACKLIGHT_MAX8925)	+= max8925_bl.o
-obj-$(CONFIG_BACKLIGHT_APPLE)	+= apple_bl.o
-obj-$(CONFIG_BACKLIGHT_TOSA)	+= tosa_bl.o
-obj-$(CONFIG_BACKLIGHT_SAHARA)	+= kb3886_bl.o
-obj-$(CONFIG_BACKLIGHT_WM831X)	+= wm831x_bl.o
-obj-$(CONFIG_BACKLIGHT_ADP5520)	+= adp5520_bl.o
-obj-$(CONFIG_BACKLIGHT_ADP8860)	+= adp8860_bl.o
-obj-$(CONFIG_BACKLIGHT_ADP8870)	+= adp8870_bl.o
-obj-$(CONFIG_BACKLIGHT_88PM860X) += 88pm860x_bl.o
+obj-$(CONFIG_BACKLIGHT_88PM860X)	+= 88pm860x_bl.o
+obj-$(CONFIG_BACKLIGHT_AAT2870)		+= aat2870_bl.o
+obj-$(CONFIG_BACKLIGHT_ADP5520)		+= adp5520_bl.o
+obj-$(CONFIG_BACKLIGHT_ADP8860)		+= adp8860_bl.o
+obj-$(CONFIG_BACKLIGHT_ADP8870)		+= adp8870_bl.o
+obj-$(CONFIG_BACKLIGHT_APPLE)		+= apple_bl.o
+obj-$(CONFIG_BACKLIGHT_ATMEL_PWM)	+= atmel-pwm-bl.o
+obj-$(CONFIG_BACKLIGHT_CARILLO_RANCH)	+= cr_bllcd.o
+obj-$(CONFIG_BACKLIGHT_CLASS_DEVICE)	+= backlight.o
+obj-$(CONFIG_BACKLIGHT_DA903X)		+= da903x_bl.o
+obj-$(CONFIG_BACKLIGHT_DA9052)		+= da9052_bl.o
+obj-$(CONFIG_BACKLIGHT_EP93XX)		+= ep93xx_bl.o
+obj-$(CONFIG_BACKLIGHT_GENERIC)		+= generic_bl.o
+obj-$(CONFIG_BACKLIGHT_HP680)		+= hp680_bl.o
+obj-$(CONFIG_BACKLIGHT_HP700)		+= jornada720_bl.o
+obj-$(CONFIG_BACKLIGHT_LM3533)		+= lm3533_bl.o
+obj-$(CONFIG_BACKLIGHT_LM3630)		+= lm3630_bl.o
+obj-$(CONFIG_BACKLIGHT_LM3639)		+= lm3639_bl.o
+obj-$(CONFIG_BACKLIGHT_LOCOMO)		+= locomolcd.o
+obj-$(CONFIG_BACKLIGHT_LP855X)		+= lp855x_bl.o
+obj-$(CONFIG_BACKLIGHT_LP8788)		+= lp8788_bl.o
+obj-$(CONFIG_BACKLIGHT_MAX8925)		+= max8925_bl.o
+obj-$(CONFIG_BACKLIGHT_OMAP1)		+= omap1_bl.o
+obj-$(CONFIG_BACKLIGHT_OT200)		+= ot200_bl.o
+obj-$(CONFIG_BACKLIGHT_PANDORA)		+= pandora_bl.o
 obj-$(CONFIG_BACKLIGHT_PCF50633)	+= pcf50633-backlight.o
-obj-$(CONFIG_BACKLIGHT_AAT2870) += aat2870_bl.o
-obj-$(CONFIG_BACKLIGHT_OT200) += ot200_bl.o
-obj-$(CONFIG_BACKLIGHT_TPS65217) += tps65217_bl.o
+obj-$(CONFIG_BACKLIGHT_PWM)		+= pwm_bl.o
+obj-$(CONFIG_BACKLIGHT_SAHARA)		+= kb3886_bl.o
+obj-$(CONFIG_BACKLIGHT_TOSA)		+= tosa_bl.o
+obj-$(CONFIG_BACKLIGHT_TPS65217)	+= tps65217_bl.o
+obj-$(CONFIG_BACKLIGHT_WM831X)		+= wm831x_bl.o
+
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
bugh-prevent-double-evaulation-of-in-build_bug_on-fix.patch
bugh-compilerh-introduce-compiletime_assert-build_bug_on_msg-checkpatch-fixes.patch
i-need-old-gcc.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v2-fix.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-fix-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix.patch
sched-proc-sched_stat-fails-on-very-very-large-machines-v2-fix-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-fix.patch
sched-proc-sched_debug-fails-on-very-very-large-machines-v2-fix.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-remove-flags-argument-to-mmap_region-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix-fix.patch
cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved-fix.patch
cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-checkpatch-fixes.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-fix.patch
acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix.patch
memory-failure-do-code-refactor-of-soft_offline_page.patch
memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages-fix.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
mm-rename-page-struct-field-helpers.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
kernel-smpc-cleanups.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-lms501kf03-lcd-driver-fix-fix.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
drivers-video-backlight-makefile-cleanup.patch
checkpatch-dont-emit-the-camelcase-warning-for-pagefoo.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix.patch
rtc-add-support-for-spi-rtc-rx4581-checkpatch-fixes.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
signal-allow-to-send-any-siginfo-to-itself-fix.patch
signalfd-add-ability-to-return-siginfo-in-a-raw-format-v2-fix.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
userns-improve-uid-gid-map-collision-detection-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
mutex-use-spin_lock-instead-of-arch_spin_lock-fix.patch
aio-kiocb_cancel-fix.patch
wait-add-wait_event_hrtimeout-fix.patch
aio-use-cancellation-list-lazily-fix-fix.patch
aio-give-shared-kioctx-fields-their-own-cachelines-fix.patch
generic-dynamic-per-cpu-refcounting-fix.patch
generic-dynamic-per-cpu-refcounting-sparse-fixes-fix.patch
generic-dynamic-per-cpu-refcounting-doc-fix.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-dont-include-aioh-in-schedh-fix-fix.patch
aio-dont-include-aioh-in-schedh-fix-3.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

