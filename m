From: akpm@linux-foundation.org
Subject: - implement-flush_work-sanity.patch removed from -mm tree
Date: Mon, 30 Apr 2007 13:16:44 -0700
Message-ID: <200704302016.l3UKGiVr013976@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031585AbXD3URU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 16:17:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     implement-flush_work-sanity
has been removed from the -mm tree.  Its filename was
     implement-flush_work-sanity.patch

This patch was dropped because it was folded into implement-flush_work.patch

------------------------------------------------------
Subject: implement-flush_work-sanity
From: Andrew Morton <akpm@osdl.org>

Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/workqueue.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/workqueue.c~implement-flush_work-sanity kernel/workqueue.c
--- a/kernel/workqueue.c~implement-flush_work-sanity
+++ a/kernel/workqueue.c
@@ -169,7 +169,7 @@ int fastcall run_scheduled_work(struct w
 }
 EXPORT_SYMBOL(run_scheduled_work);
 
-static inline void insert_work(struct cpu_workqueue_struct *cwq,
+static void insert_work(struct cpu_workqueue_struct *cwq,
 				struct work_struct *work, int tail)
 {
 	set_wq_data(work, cwq);
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
git-powerpc.patch
git-ia64.patch
git-ieee1394.patch
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
epoll-optimizations-and-cleanups.patch
sync_sb_inodes-propagate-errors.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
schedule_on_each_cpu-use-preempt_disable.patch
implement-flush_work.patch
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
