From: akpm@linux-foundation.org
Subject: - doc-add-printk-formatstxt-fix.patch removed from -mm tree
Date: Wed, 12 Nov 2008 13:16:36 -0800
Message-ID: <200811122116.mACLGb36021554@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753211AbYKLVRM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 16:17:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@gmail.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     doc-add-printk-formatstxt-fix
has been removed from the -mm tree.  Its filename was
     doc-add-printk-formatstxt-fix.patch

This patch was dropped because it was folded into doc-add-printk-formatstxt.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: doc-add-printk-formatstxt-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/printk-formats.txt |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN Documentation/printk-formats.txt~doc-add-printk-formatstxt-fix Documentation/printk-formats.txt
--- a/Documentation/printk-formats.txt~doc-add-printk-formatstxt-fix
+++ a/Documentation/printk-formats.txt
@@ -32,5 +32,4 @@ Reminder: sizeof() result is of type siz
 Thank you for your cooperation and attention.
 
 
-Written by Alexey Dobriyan <adobriyan@gmail.com>
-Updated by Randy Dunlap <rdunlap@xenotime.net>
+By Randy Dunlap <rdunlap@xenotime.net>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cpusets-update-mems-allowed-in-page-allocator.patch
remove-ratelimt.patch
doc-add-printk-formatstxt.patch
doc-add-printk-formatstxt-fix.patch
kernel-kprobesc-dont-pad-kretprobe_table_locks-on-uniprocessor-builds.patch
rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch
rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
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
bdi-register-sysfs-bdi-device-only-once-per-queue-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
init-properly-placing-noinline-keyword.patch
binfmtsh-include-listh-fix.patch
spi_gpio-driver-cleanups.patch
quota-permit-separately-enabling-quota-accounting-and-enforcing-limits-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix-2.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
quota-support-64-bit-quota-format-fix.patch
quota-support-64-bit-quota-format-fix-2.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
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

