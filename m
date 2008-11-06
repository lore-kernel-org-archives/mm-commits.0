From: akpm@linux-foundation.org
Subject: + binfmtsh-include-listh-fix.patch added to -mm tree
Date: Thu, 06 Nov 2008 12:20:35 -0800
Message-ID: <200811062035.mA6KZbP7005162@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750698AbYKFUga (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Nov 2008 15:36:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, h-shimamoto@ct.jp.nec.com


The patch titled
     binfmtsh-include-listh-fix
has been added to the -mm tree.  Its filename is
     binfmtsh-include-listh-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: binfmtsh-include-listh-fix
From: Andrew Morton <akpm@linux-foundation.org>

/usr/src/devel/usr/include/linux/binfmts.h:4: included file 'linux/list.h' is not exported

Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/binfmts.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/binfmts.h~binfmtsh-include-listh-fix include/linux/binfmts.h
--- a/include/linux/binfmts.h~binfmtsh-include-listh-fix
+++ a/include/linux/binfmts.h
@@ -1,7 +1,6 @@
 #ifndef _LINUX_BINFMTS_H
 #define _LINUX_BINFMTS_H
 
-#include <linux/list.h>
 #include <linux/capability.h>
 
 struct pt_regs;
@@ -19,6 +18,7 @@ struct pt_regs;
 #define BINPRM_BUF_SIZE 128
 
 #ifdef __KERNEL__
+#include <linux/list.h>
 
 #define CORENAME_MAX_SIZE 128
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

autofs4-collect-version-check-return-checkpatch-fixes.patch
maintainers-make-ioat-easier-to-find.patch
binfmtsh-include-listh-fix.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
pci-uninline-pci_ioremap_bar.patch
pcie-add-option-to-passively-listen-for-pcie-hotplug-events-checkpatch-fixes.patch
cpusets-update-mems-allowed-in-page-allocator-fix.patch
bdi-register-sysfs-bdi-device-only-once-per-queue-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
alsa-fix-snd_bug_on-and-friends.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
init-properly-placing-noinline-keyword.patch
spi_gpio-driver-cleanups.patch
rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch
rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock-fix.patch
quota-permit-separately-enabling-quota-accounting-and-enforcing-limits-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix-2.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
quota-support-64-bit-quota-format-fix.patch
quota-support-64-bit-quota-format-fix-2.patch
quota-add-reservation-support-for-delayed-block-allocation-checkpatch-fixes.patch
quota-add-quota-claim-and-release-reserved-quota-blocks-operations-checkpatch-fixes.patch
ext4-quota-handling-for-delayed-allocation-checkpatch-fixes.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
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

