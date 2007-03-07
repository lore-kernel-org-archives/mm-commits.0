From: akpm@linux-foundation.org
Subject: - squash-udf-warnings.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:17:09 -0800
Message-ID: <200703070417.l274H9gS018763@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46804 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161261AbXCGERL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:17:11 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l274HAq8002030
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Tue, 6 Mar 2007 20:17:10 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     squash-udf-warnings
has been removed from the -mm tree.  Its filename was
     squash-udf-warnings.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: squash-udf-warnings
From: Andrew Morton <akpm@osdl.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/balloc.c |    2 +-
 fs/udf/super.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/udf/balloc.c~squash-udf-warnings fs/udf/balloc.c
--- a/fs/udf/balloc.c~squash-udf-warnings
+++ a/fs/udf/balloc.c
@@ -748,7 +748,7 @@ static int udf_table_new_block(struct su
 	uint32_t spread = 0xFFFFFFFF, nspread = 0xFFFFFFFF;
 	uint32_t newblock = 0, adsize;
 	uint32_t extoffset, goal_extoffset, elen, goal_elen = 0;
-	kernel_lb_addr bloc, goal_bloc, eloc, goal_eloc;
+	kernel_lb_addr bloc, goal_bloc, eloc, goal_eloc = {};
 	struct buffer_head *bh, *goal_bh;
 	int8_t etype;
 
diff -puN fs/udf/super.c~squash-udf-warnings fs/udf/super.c
--- a/fs/udf/super.c~squash-udf-warnings
+++ a/fs/udf/super.c
@@ -1360,7 +1360,7 @@ udf_load_partition(struct super_block *s
 			case UDF_VIRTUAL_MAP15:
 			case UDF_VIRTUAL_MAP20:
 			{
-				kernel_lb_addr ino;
+				kernel_lb_addr ino = {};
 
 				memset(&ino, 0, sizeof(ino));
 
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-ia64.patch
git-ieee1394.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
git-ubi.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-uninline-skb_put.patch
git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-dont-include-bugsh.patch
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
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
aio-is-unlikely.patch
mm-implement-swap-prefetching.patch
rcu-preemptible-rcu.patch
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
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
ia64-enable-config_debug_spinlock_sleep.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch
