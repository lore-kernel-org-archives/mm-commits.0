From: akpm@linux-foundation.org
Subject: - drivers-mfd-ucb1400_corec-needs-gpio.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:20:46 -0700
Message-ID: <200810182320.m9INKkX9029826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751936AbYJRXUt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:20:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, sameo@openedhand.com, mm-commits@vger.kernel.org


The patch titled
     drivers/mfd/ucb1400_core.c needs GPIO
has been removed from the -mm tree.  Its filename was
     drivers-mfd-ucb1400_corec-needs-gpio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/mfd/ucb1400_core.c needs GPIO
From: Andrew Morton <akpm@linux-foundation.org>

ia64 allmodconfig:

In file included from include/linux/ucb1400.h:27,
                 from drivers/mfd/ucb1400_core.c:24:
include/asm-generic/gpio.h: In function `gpio_get_value_cansleep':
include/asm-generic/gpio.h:147: error: implicit declaration of function `gpio_get_value'
include/asm-generic/gpio.h: In function `gpio_set_value_cansleep':
include/asm-generic/gpio.h:153: error: implicit declaration of function `gpio_set_value'
drivers/mfd/ucb1400_core.c: At top level:

Acked-by: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/mfd/Kconfig~drivers-mfd-ucb1400_corec-needs-gpio drivers/mfd/Kconfig
--- a/drivers/mfd/Kconfig~drivers-mfd-ucb1400_corec-needs-gpio
+++ a/drivers/mfd/Kconfig
@@ -53,6 +53,7 @@ config HTC_PASIC3
 config UCB1400_CORE
 	tristate "Philips UCB1400 Core driver"
 	depends on AC97_BUS
+	depends on GPIOLIB
 	help
 	  This enables support for the Philips UCB1400 core functions.
 	  The UCB1400 is an AC97 audio codec.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix-fix.patch
vmscan-fix-pagecache-reclaim-referenced-bit-check-fix-fix-fix.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-rewrite-vmap-layer.patch
memory_probe-fix-wrong-sysfs-file-attribute-fix.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms-cleanup.patch
drivers-hwmon-applesmcc-remove-unneeded-casts.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
x86-sysfs-kill-owner-field-from-attribute-fix.patch
x86-sysfs-kill-owner-field-from-attribute-fix-3.patch

