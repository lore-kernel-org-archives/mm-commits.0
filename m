From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Thu, 14 Apr 2011 11:37:05 -0700
Message-ID: <201104141833.p3EIXrqO031443@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37600 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932742Ab1DNSeY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Apr 2011 14:34:24 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id p3EIXsP5023234
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 14 Apr 2011 11:33:54 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   16 ----------------
 1 file changed, 16 deletions(-)

diff -puN kernel/sched.c~linux-next-git-rejects kernel/sched.c
--- a/kernel/sched.c~linux-next-git-rejects
+++ a/kernel/sched.c
@@ -4187,26 +4187,11 @@ need_resched:
 			if (prev->flags & PF_WQ_WORKER)
 				to_wakeup = wq_worker_sleeping(prev, cpu);
 			deactivate_task(rq, prev, DEQUEUE_SLEEP);
-<<<<<<< HEAD
-
-			/*
-			 * If we are going to sleep and we have plugged IO queued, make
-			 * sure to submit it to avoid deadlocks.
-			 */
-			if (blk_needs_flush_plug(prev)) {
-				raw_spin_unlock(&rq->lock);
-				blk_flush_plug(prev);
-				raw_spin_lock(&rq->lock);
-			}
-=======
 			prev->on_rq = 0;
->>>>>>> FETCH_HEAD
 		}
 		switch_count = &prev->nvcsw;
 	}
 
-<<<<<<< HEAD
-=======
 	/*
 	 * If we are going to sleep and we have plugged IO queued, make
 	 * sure to submit it to avoid deadlocks.
@@ -4223,7 +4208,6 @@ need_resched:
 	 */
 	if (to_wakeup)
 		try_to_wake_up_local(to_wakeup);
->>>>>>> FETCH_HEAD
 	pre_schedule(rq, prev);
 	if (unlikely(!rq->nr_running))
 		idle_balance(cpu, rq);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-i2c-busses-i2c-designware-corec-needs-delayh.patch
fs-partitions-ldmc-fix-oops-caused-by-corrupted-partition-table-checkpatch-fixes.patch
mm-add-vm-counters-for-transparent-hugepages.patch
mm-thp-use-conventional-format-for-boolean-attributes-fix.patch
vfs-avoid-large-kmallocs-for-the-fdtable.patch
drivers-scsi-mpt2sas-mpt2sas_ctlc-fix-unbounded-copy_to_user.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-video-backlight-adp5520_blc-check-strict_strtoul-return-value-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
osst-wrong-index-used-in-inner-loop-checkpatch-fixes.patch
drbd-fix-warning.patch
mm.patch
mm-nommu-sort-mm-mmap-list-properly-fix.patch
mm-per-node-vmstat-show-proper-vmstats-fix.patch
mm-mem-hotplug-update-pcp-stat_threshold-when-memory-hotplug-occur-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix.patch
lru_cache-use-correct-type-in-sizeof-for-allocation-fix.patch
lib-genpoolc-document-return-values-fix-gen_pool_add_virt-return-value.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
fs-ncpfs-inodec-suppress-used-uninitialised-warning.patch
drivers-tty-vt-vt_ioctlc-repair-insane-expression.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region-fix.patch
rtc-driver-for-pt7c4338-chip-checkpatch-fixes.patch
rtc-driver-for-pt7c4338-chip-fix.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
add-the-pagefault-count-into-memcg-stats-fix.patch
dev-kmsg-properly-support-writev-to-avoid-interleaved-printk-lines-fix.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

