From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Mon, 29 Apr 2013 11:39:38 -0700
Message-ID: <20130429183938.62FB131C03C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:51939 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758062Ab3D2Sjj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 14:39:39 -0400
Received: by mail-ye0-f201.google.com with SMTP id m3so107433yen.0
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 11:39:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/scan.c               |    3 ---
 drivers/gpio/gpio-pl061.c         |    3 ---
 drivers/pinctrl/Makefile          |    3 ---
 drivers/pinctrl/pinctrl-samsung.c |    3 ---
 drivers/pinctrl/pinctrl-samsung.h |    3 ---
 drivers/video/Kconfig             |   13 -------------
 include/linux/pci.h               |    3 ---
 7 files changed, 31 deletions(-)

diff -puN drivers/acpi/scan.c~linux-next-git-rejects drivers/acpi/scan.c
--- a/drivers/acpi/scan.c~linux-next-git-rejects
+++ a/drivers/acpi/scan.c
@@ -2044,10 +2044,7 @@ int __init acpi_scan_init(void)
 	acpi_lpss_init();
 	acpi_csrt_init();
 	acpi_container_init();
-<<<<<<< HEAD
-=======
 	acpi_memory_hotplug_init();
->>>>>>> linux-next/akpm-base
 
 	mutex_lock(&acpi_scan_lock);
 	/*
diff -puN drivers/gpio/gpio-pl061.c~linux-next-git-rejects drivers/gpio/gpio-pl061.c
--- a/drivers/gpio/gpio-pl061.c~linux-next-git-rejects
+++ a/drivers/gpio/gpio-pl061.c
@@ -15,10 +15,7 @@
 #include <linux/io.h>
 #include <linux/ioport.h>
 #include <linux/irq.h>
-<<<<<<< HEAD
-=======
 #include <linux/irqchip/chained_irq.h>
->>>>>>> linux-next/akpm-base
 #include <linux/irqdomain.h>
 #include <linux/bitops.h>
 #include <linux/workqueue.h>
diff -puN drivers/pinctrl/Makefile~linux-next-git-rejects drivers/pinctrl/Makefile
--- a/drivers/pinctrl/Makefile~linux-next-git-rejects
+++ a/drivers/pinctrl/Makefile
@@ -21,10 +21,7 @@ obj-$(CONFIG_PINCTRL_IMX35)	+= pinctrl-i
 obj-$(CONFIG_PINCTRL_IMX51)	+= pinctrl-imx51.o
 obj-$(CONFIG_PINCTRL_IMX53)	+= pinctrl-imx53.o
 obj-$(CONFIG_PINCTRL_IMX6Q)	+= pinctrl-imx6q.o
-<<<<<<< HEAD
-=======
 obj-$(CONFIG_PINCTRL_IMX6Q)	+= pinctrl-imx6dl.o
->>>>>>> linux-next/akpm-base
 obj-$(CONFIG_PINCTRL_FALCON)	+= pinctrl-falcon.o
 obj-$(CONFIG_PINCTRL_MXS)	+= pinctrl-mxs.o
 obj-$(CONFIG_PINCTRL_IMX23)	+= pinctrl-imx23.o
diff -puN drivers/pinctrl/pinctrl-samsung.c~linux-next-git-rejects drivers/pinctrl/pinctrl-samsung.c
--- a/drivers/pinctrl/pinctrl-samsung.c~linux-next-git-rejects
+++ a/drivers/pinctrl/pinctrl-samsung.c
@@ -975,11 +975,8 @@ static const struct of_device_id samsung
 	{ .compatible = "samsung,s3c64xx-pinctrl",
 		.data = s3c64xx_pin_ctrl },
 #endif
-<<<<<<< HEAD
-=======
 	{ .compatible = "samsung,exynos5250-pinctrl",
 		.data = (void *)exynos5250_pin_ctrl },
->>>>>>> linux-next/akpm-base
 	{},
 };
 MODULE_DEVICE_TABLE(of, samsung_pinctrl_dt_match);
diff -puN drivers/pinctrl/pinctrl-samsung.h~linux-next-git-rejects drivers/pinctrl/pinctrl-samsung.h
--- a/drivers/pinctrl/pinctrl-samsung.h~linux-next-git-rejects
+++ a/drivers/pinctrl/pinctrl-samsung.h
@@ -245,9 +245,6 @@ struct samsung_pmx_func {
 extern struct samsung_pin_ctrl exynos4210_pin_ctrl[];
 extern struct samsung_pin_ctrl exynos4x12_pin_ctrl[];
 extern struct samsung_pin_ctrl s3c64xx_pin_ctrl[];
-<<<<<<< HEAD
-=======
 extern struct samsung_pin_ctrl exynos5250_pin_ctrl[];
->>>>>>> linux-next/akpm-base
 
 #endif /* __PINCTRL_SAMSUNG_H */
diff -puN drivers/video/Kconfig~linux-next-git-rejects drivers/video/Kconfig
--- a/drivers/video/Kconfig~linux-next-git-rejects
+++ a/drivers/video/Kconfig
@@ -1792,7 +1792,6 @@ config FB_WM8505
 	select FB_SYS_IMAGEBLIT
 	select FB_MODE_HELPERS
 	select VIDEOMODE_HELPERS
-<<<<<<< HEAD
 	help
 	  This is the framebuffer driver for WonderMedia WM8xxx-series
 	  integrated LCD controller. This driver covers the WM8505, WM8650
@@ -1803,18 +1802,6 @@ config FB_WMT_GE_ROPS
 	depends on (FB = y) && (FB_VT8500 || FB_WM8505)
 	default n
 	help
-=======
-	help
-	  This is the framebuffer driver for WonderMedia WM8xxx-series
-	  integrated LCD controller. This driver covers the WM8505, WM8650
-	  and WM8850 SoCs.
-
-config FB_WMT_GE_ROPS
-	bool "VT8500/WM8xxx accelerated raster ops support"
-	depends on (FB = y) && (FB_VT8500 || FB_WM8505)
-	default n
-	help
->>>>>>> linux-next/akpm-base
 	  This adds support for accelerated raster operations on the
 	  VIA VT8500 and Wondermedia 85xx series SoCs.
 
diff -puN include/linux/pci.h~linux-next-git-rejects include/linux/pci.h
--- a/include/linux/pci.h~linux-next-git-rejects
+++ a/include/linux/pci.h
@@ -1661,10 +1661,7 @@ int pci_enable_sriov(struct pci_dev *dev
 void pci_disable_sriov(struct pci_dev *dev);
 irqreturn_t pci_sriov_migration(struct pci_dev *dev);
 int pci_num_vf(struct pci_dev *dev);
-<<<<<<< HEAD
-=======
 int pci_vfs_assigned(struct pci_dev *dev);
->>>>>>> linux-next/akpm-base
 int pci_sriov_set_totalvfs(struct pci_dev *dev, u16 numvfs);
 int pci_sriov_get_totalvfs(struct pci_dev *dev);
 #else
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
drivers-usb-storage-realtek_crc-fix-build.patch
revert-ipc-dont-allocate-a-copy-larger-than-max.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
auditsc-use-kzalloc-instead-of-kmallocmemset-fix.patch
kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees-fix.patch
drivers-video-implement-a-simple-framebuffer-driver-fix.patch
inotify-invalid-mask-should-return-a-error-number-but-not-set-it-fix.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
include-linux-mfd-si476x-coreh-dont-use-0bnnn.patch
mm.patch
mm-shmemc-remove-an-ifdef.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
staging-zcache-enable-ramster-to-be-built-loaded-as-a-module-fix.patch
memcg-relax-memcg-iter-caching-checkpatch-fixes.patch
mm-hugetlb-add-more-arch-defined-huge_pte-functions-fix.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation.patch
kexec-vmalloc-export-additional-vmalloc-layer-information-fix.patch
mm-hugetlb-include-hugepages-in-meminfo-checkpatch-fixes.patch
mm-speedup-in-__early_pfn_to_nid.patch
mm-speedup-in-__early_pfn_to_nid-fix.patch
include-linux-memoryh-implement-register_hotmemory_notifier.patch
ipc-utilc-use-register_hotmemory_notifier.patch
mm-slubc-use-register_hotmemory_notifier.patch
drivers-base-nodec-switch-to-register_hotmemory_notifier.patch
fs-proc-kcorec-use-register_hotmemory_notifier.patch
kernel-cpusetc-use-register_hotmemory_notifier.patch
mm-limit-growth-of-3%-hardcoded-other-user-reserve.patch
mm-replace-hardcoded-3%-with-admin_reserve_pages-knob.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed-v9-checkpatch-fixes.patch
resource-add-release_mem_region_adjustable-fix.patch
resource-add-release_mem_region_adjustable-fix-fix.patch
resource-add-release_mem_region_adjustable-fix-fix-fix.patch
mm-madvise-complete-input-validation-before-taking-lock-fix.patch
clear_refs-sanitize-accepted-commands-declaration-fix.patch
selftest-add-simple-test-for-soft-dirty-bit.patch
memcg-add-memorypressure_level-events-checkpatch-fixes.patch
memcg-add-memorypressure_level-events-fix.patch
mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix-fix.patch
thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0-fix.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix-fix.patch
mem-hotunplug-fix-kfree-of-bootmem-memory-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device-fix.patch
genalloc-add-devres-support-allow-to-find-a-managed-pool-by-device-fix-fix.patch
misc-generic-on-chip-sram-allocation-driver-fix.patch
kernel-smpc-cleanups.patch
early_printk-consolidate-random-copies-of-identical-code-v3-fix.patch
include-linux-printkh-include-stdargh.patch
get_maintainer-use-filename-only-regex-match-for-tegra-fix.patch
argv_split-teach-it-to-handle-mutable-strings-fix.patch
lib-string_helpers-introduce-generic-string_unescape-fix.patch
kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc-checkpatch-fixes.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-mainc-convert-to-pr_foo.patch
init-mainc-convert-to-pr_foo-fix.patch
init-mainc-convert-to-pr_foo-fix-fix.patch
rtc-ds1307-long-block-operations-bugfix.patch
nilfs2-fix-issue-with-flush-kernel-thread-after-remount-in-ro-mode-because-of-drivers-internal-error-or-metadata-corruption-fix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
fat-additions-to-support-fat_fallocate-fix.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
ipc-introduce-obtaining-a-lockless-ipc-object-fix.patch
ipcsem-do-not-hold-ipc-lock-more-than-necessary-fix-checkpatch-fixes.patch
ipcsem-open-code-and-rename-sem_lock-fix.patch
ipcsem-fine-grained-locking-for-semtimedop-ipc-make-refcounter-atomic-fix.patch
ipc-sysv-shared-memory-limited-to-8tib-fix.patch
rapidio-make-enumeration-discovery-configurable-fix.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
gadget-remove-only-user-of-aio-retry-checkpatch-fixes.patch
aio-remove-retry-based-aio-checkpatch-fixes.patch
aio-add-kiocb_cancel.patch
aio-make-aio_put_req-lockless-checkpatch-fixes.patch
aio-refcounting-cleanup-checkpatch-fixes.patch
wait-add-wait_event_hrtimeout.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers-checkpatch-fixes.patch
aio-use-cancellation-list-lazily.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
generic-dynamic-per-cpu-refcounting.patch
generic-dynamic-per-cpu-refcounting-checkpatch-fixes.patch
aio-dont-include-aioh-in-schedh.patch
aio-dont-include-aioh-in-schedh-fix.patch
aio-kill-ki_retry.patch
aio-kill-ki_retry-fix.patch
aio-kill-ki_retry-checkpatch-fixes.patch
block-prep-work-for-batch-completion-checkpatch-fixes.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-4.patch
block-prep-work-for-batch-completion-fix-99.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
bpf-add-comments-explaining-the-schedule_work-operation.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

