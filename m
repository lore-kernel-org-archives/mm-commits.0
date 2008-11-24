From: akpm@linux-foundation.org
Subject: + ntfs-dont-fool-kernel-doc-checkpatch-fixes.patch added to -mm tree
Date: Mon, 24 Nov 2008 13:26:07 -0800
Message-ID: <200811242126.mAOLQ7Ow024975@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752453AbYKXV0Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 16:26:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, aia21@cantab.net, randy.dunlap@oracle.com


The patch titled
     ntfs-dont-fool-kernel-doc-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     ntfs-dont-fool-kernel-doc-checkpatch-fixes.patch

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
Subject: ntfs-dont-fool-kernel-doc-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: space prohibited between function name and open parenthesis '('
#23: FILE: fs/ntfs/debug.h:33:
+extern void __ntfs_debug (const char *file, int line, const char *function,

total: 0 errors, 1 warnings, 20 lines checked

./patches/ntfs-dont-fool-kernel-doc.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Anton Altaparmakov <aia21@cantab.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/debug.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ntfs/debug.h~ntfs-dont-fool-kernel-doc-checkpatch-fixes fs/ntfs/debug.h
--- a/fs/ntfs/debug.h~ntfs-dont-fool-kernel-doc-checkpatch-fixes
+++ a/fs/ntfs/debug.h
@@ -30,7 +30,7 @@
 
 extern int debug_msgs;
 
-extern void __ntfs_debug (const char *file, int line, const char *function,
+extern void __ntfs_debug(const char *file, int line, const char *function,
 	const char *format, ...) __attribute__ ((format (printf, 4, 5)));
 /**
  * ntfs_debug - write a debug level message to syslog
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

epoll-introduce-resource-usage-limits-fix.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
input-ad7879-fix-workaroud-build-error-reported-by-andrew-morton.patch
pci-uninline-pci_ioremap_bar.patch
pcie-add-option-to-passively-listen-for-pcie-hotplug-events-checkpatch-fixes.patch
vfs-lseekfd-0-seek_cur-race-condition-fix.patch
ntfs-dont-fool-kernel-doc-checkpatch-fixes.patch
bdi-register-sysfs-bdi-device-only-once-per-queue-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
netdev-smc911x-fix-for-driver-resume-cleanup.patch
kernel-profilec-fix-section-mismatch-warning-fix.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
poll-allow-f_op-poll-to-sleep-take-2-checkpatch-fixes.patch
binfmtsh-include-listh-fix.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
spi_gpio-driver-cleanups.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-support-probing-module-__exit-function-fix-2.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
quota-permit-separately-enabling-quota-accounting-and-enforcing-limits-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix-2.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
quota-support-64-bit-quota-format-fix.patch
quota-support-64-bit-quota-format-fix-2.patch
quota-cleanup-use-inode-i_blkbits-to-get-block-bits-fix.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
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

