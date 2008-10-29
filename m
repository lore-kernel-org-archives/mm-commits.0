From: akpm@linux-foundation.org
Subject: - linux-timexh-cleanup-for-userspace-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 29 Oct 2008 14:17:26 -0700
Message-ID: <200810292117.m9TLHRo2018233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752897AbYJ2VSG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Oct 2008 17:18:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, tglx@linutronix.de, vapier@gentoo.org, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     linux-timexh-cleanup-for-userspace-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     linux-timexh-cleanup-for-userspace-checkpatch-fixes.patch

This patch was dropped because it was folded into linux-timexh-cleanup-for-userspace.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-timexh-cleanup-for-userspace-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: Use #include <linux/param.h> instead of <asm/param.h>
#73: FILE: include/linux/timex.h:169:
+#include <asm/param.h>

WARNING: line over 80 characters
#107: FILE: include/linux/timex.h:203:
+#define NTP_PHASE_LIMIT ((MAXPHASE / NSEC_PER_USEC) << 5) /* beyond max. dispersion */

total: 0 errors, 2 warnings, 93 lines checked

./patches/linux-timexh-cleanup-for-userspace.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/timex.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/timex.h~linux-timexh-cleanup-for-userspace-checkpatch-fixes include/linux/timex.h
--- a/include/linux/timex.h~linux-timexh-cleanup-for-userspace-checkpatch-fixes
+++ a/include/linux/timex.h
@@ -165,8 +165,8 @@ struct timex {
 #ifdef __KERNEL__
 #include <linux/compiler.h>
 #include <linux/types.h>
+#include <linux/param.h>
 
-#include <asm/param.h>
 #include <asm/timex.h>
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

freezer_cg-use-thaw_process-in-unfreeze_cgroup.patch
fs-remove-prepare_write-commit_write.patch
mm-write_cache_pages-writepage-error-fix.patch
nfsd-fix-vm-overcommit-crash.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
linux-next-rejects.patch
next-remove-localversion.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
linux-timexh-cleanup-for-userspace-checkpatch-fixes.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
kbuild-prevent-modpost-from-looking-for-a-cmd-file-for-a-static-library-linked-into-a-module.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
drivers-rtc-rtc-ds1286c-is-borked.patch
drivers-rtc-rtc-m48t35c-is-borked-too.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
pci-uninline-pci_ioremap_bar.patch
autofs4-collect-version-check-return-checkpatch-fixes.patch
maintainers-make-ioat-easier-to-find.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
fs-truncate-blocks-outside-i_size-after-generic_file_direct_write-error-fix.patch
init-properly-placing-noinline-keyword.patch
spi_gpio-driver-cleanups.patch
rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch
rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix-2.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
quota-support-64-bit-quota-format-fix.patch
quota-support-64-bit-quota-format-fix-2.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-broke.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

