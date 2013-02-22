From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-makefile-cleanup.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:42:06 -0800
Message-ID: <20130222204206.912CE5A4282@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:48015 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab3BVUmH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:42:07 -0500
Received: by mail-qc0-f202.google.com with SMTP id k26so103984qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:42:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/Makefile: cleanup
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-makefile-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/video/backlight/Makefile: cleanup

Fix up indenting.  Also alphasort all entries, which reduces patch
collisions.

Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/Makefile |   90 ++++++++++++++---------------
 1 file changed, 45 insertions(+), 45 deletions(-)

diff -puN drivers/video/backlight/Makefile~drivers-video-backlight-makefile-cleanup drivers/video/backlight/Makefile
--- a/drivers/video/backlight/Makefile~drivers-video-backlight-makefile-cleanup
+++ a/drivers/video/backlight/Makefile
@@ -1,49 +1,49 @@
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
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
drivers-md-persistent-data-dm-transaction-managerc-rename-hash_size.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
sched-proc-sched_stat-fails-on-very-very-large-machines.patch
sched-proc-sched_debug-fails-on-very-very-large-machines.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
mmotm-memcgvmscan-do-not-break-out-targeted-reclaim-without-reclaimed-pagespatch-fix-fix.patch
mm-make-madvisemadv_willneed-support-swap-file-prefetch-fix.patch
mm-compaction-make-__compact_pgdat-and-compact_pgdat-return-void.patch
mm-remove-flags-argument-to-mmap_region-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix.patch
memory-hotplug-remove-sys-firmware-memmap-x-sysfs-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix-fix.patch
memory-hotplug-common-apis-to-support-page-tables-hot-remove-fix-fix-fix-fix-fix-fix-fix.patch
memory-hotplug-remove-page-table-of-x86_64-architecture-fix.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix.patch
memory-hotplug-do-not-allocate-pdgat-if-it-was-not-freed-when-offline-fix-fix.patch
cpu_hotplug-clear-apicid-to-node-when-the-cpu-is-hotremoved-fix.patch
cpu-hotplugmemory-hotplug-clear-cpu_to_node-when-offlining-the-node-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-checkpatch-fixes.patch
page_alloc-add-movable_memmap-kernel-parameter-fix-fix-fix.patch
acpi-memory-hotplug-extend-movablemem_map-ranges-to-the-end-of-node-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix.patch
acpi-memory-hotplug-support-getting-hotplug-info-from-srat-fix-fix.patch
memory-failure-do-code-refactor-of-soft_offline_page.patch
memory-failure-use-num_poisoned_pages-instead-of-mce_bad_pages-fix.patch
mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp-fix.patch
mm-dont-inline-page_mapping.patch
swap-make-each-swap-partition-have-one-address_space-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix.patch
page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory-fix-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix.patch
memcg-reduce-the-size-of-struct-memcg-244-fold-fix-fix.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
mm-rename-page-struct-field-helpers.patch
mm-rename-page-struct-field-helpers-fix.patch
mm-page_alloc-add-informative-debugging-message-in-page_outside_zone_boundaries-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
hwpoison-fix-misjudgement-of-page_action-for-errors-on-mlocked-pages-fix.patch
mm-accurately-document-nr_free__pages-functions-with-code-comments-fix.patch
tmpfs-fix-mempolicy-object-leaks-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
signal-allow-to-send-any-siginfo-to-itself-fix.patch
fs-proc-clean-up-printks.patch
fs-proc-clean-up-printks-fix.patch
fs-proc-clean-up-printks-fix-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix.patch
lockdep-check-that-no-locks-held-at-freeze-time-fix.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch
idr-remove-length-restriction-from-idr_layer-bitmap-checkpatch-fixes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
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
aio-dont-include-aioh-in-schedh-fix-3-fix.patch
aio-dont-include-aioh-in-schedh-fix-3-fix-fix.patch
aio-kill-ki_retry-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix.patch
block-aio-batch-completion-for-bios-kiocbs-fix-fix-fix-fix-fix-fix.patch
selftests-add-tests-for-efivarfs-fix.patch
selftests-add-tests-for-efivarfs-fix-fix.patch
tools-testing-selftests-makefile-rearrange-targets.patch
selftests-add-a-simple-doc-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch
hlist-drop-the-node-parameter-from-iterators-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

