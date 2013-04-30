From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:17:39 -0700
Message-ID: <20130430181739.B03D75A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:34616 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760751Ab3D3SRn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:17:43 -0400
Received: by mail-vb0-f74.google.com with SMTP id w8so81039vbf.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:17:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

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
clear_refs-sanitize-accepted-commands-declaration.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
drivers-usb-storage-realtek_crc-fix-build.patch
revert-ipc-dont-allocate-a-copy-larger-than-max.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
inotify-invalid-mask-should-return-a-error-number-but-not-set-it-fix.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
staging-zcache-enable-ramster-to-be-built-loaded-as-a-module-fix.patch
selftest-add-simple-test-for-soft-dirty-bit.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
lib-string_helpers-introduce-generic-string_unescape-fix.patch
kernel-timerc-ove-some-non-timer-related-syscalls-to-kernel-sysc-checkpatch-fixes.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
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

