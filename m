From: akpm@linux-foundation.org
Subject: - git-block-xfs-barriers-broke.patch removed from -mm tree
Date: Sat, 21 Apr 2007 21:59:36 -0700
Message-ID: <200704220502.l3M52B0g019934@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40626 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754089AbXDVFCu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 22 Apr 2007 01:02:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, clameter@engr.sgi.com, dgc@sgi.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     git-block: xfs barriers broke
has been removed from the -mm tree.  Its filename was
     git-block-xfs-barriers-broke.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-block: xfs barriers broke
From: Andrew Morton <akpm@osdl.org>

Hopefully this will get xfs working in -mm.

Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Cc: David Chinner <dgc@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/linux-2.6/xfs_buf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/xfs/linux-2.6/xfs_buf.c~git-block-xfs-barriers-broke fs/xfs/linux-2.6/xfs_buf.c
--- a/fs/xfs/linux-2.6/xfs_buf.c~git-block-xfs-barriers-broke
+++ a/fs/xfs/linux-2.6/xfs_buf.c
@@ -1164,7 +1164,7 @@ _xfs_buf_ioapply(
 
 	if (bp->b_flags & XBF_ORDERED) {
 		ASSERT(!(bp->b_flags & XBF_READ));
-		rw = WRITE_BARRIER;
+		rw = WRITE;
 	} else if (bp->b_flags & _XBF_RUN_QUEUES) {
 		ASSERT(!(bp->b_flags & XBF_READ_AHEAD));
 		bp->b_flags &= ~_XBF_RUN_QUEUES;
_

Patches currently in -mm which might be from akpm@osdl.org are

git-powerpc.patch
git-ia64.patch
git-ieee1394.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
git-ubi.patch
git-netdev-all.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-ipwireless_cs.patch
lumpy-reclaim-v4.patch
deprecate-smbfs-in-favour-of-cifs.patch
block_write_full_page-handle-enospc.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
epoll-optimizations-and-cleanups-tidy.patch
sync_sb_inodes-propagate-errors.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
schedule_on_each_cpu-use-preempt_disable.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc.patch
move-page-writeback-acounting-out-of-macros.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
aio-is-unlikely.patch
mm-implement-swap-prefetching.patch
readahead-kconfig-options.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-context-based-method.patch
readahead-call-scheme.patch
readahead-nfsd-case.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
acpi_format_exception-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
