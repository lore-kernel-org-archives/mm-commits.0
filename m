From: akpm@linux-foundation.org
Subject: - fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix.patch removed from -mm tree
Date: Wed, 09 May 2007 03:04:42 -0700
Message-ID: <200705091004.l49A4gHd020774@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754834AbXEIKEt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 06:04:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, suparna@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio fix
has been removed from the -mm tree.  Its filename was
     fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio fix
From: Andrew Morton <akpm@osdl.org>

fs/aio.c:665: warning: initialization from incompatible pointer type
fs/aio.c:724: warning: assignment from incompatible pointer type

Cc: Suparna Bhattacharya <suparna@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/aio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/aio.c~fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix fs/aio.c
--- a/fs/aio.c~fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix
+++ a/fs/aio.c
@@ -662,7 +662,7 @@ static ssize_t aio_run_iocb(struct kiocb
 {
 	struct kioctx	*ctx = iocb->ki_ctx;
 	ssize_t (*retry)(struct kiocb *);
-	struct wait_queue_t *io_wait = current->io_wait;
+	wait_queue_t *io_wait = current->io_wait;
 	ssize_t ret;
 
 	if (!(retry = iocb->ki_retry)) {
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
schedule_on_each_cpu-use-preempt_disable.patch
implement-flush_work.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
aio-is-unlikely.patch
git-ia64.patch
git-ieee1394.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-ipwireless_cs.patch
lumpy-reclaim-v4.patch
deprecate-smbfs-in-favour-of-cifs.patch
sync_sb_inodes-propagate-errors.patch
move-page-writeback-acounting-out-of-macros.patch
ext2-reservations.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix.patch
mm-implement-swap-prefetching.patch
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
