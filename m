From: akpm@linux-foundation.org
Subject: [folded-merged] loop-cleanup-partitions-when-detaching-loop-device-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 25 Mar 2013 12:40:21 -0700
Message-ID: <20130325194022.1B5E531C1B3@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:52033 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758887Ab3CYTkY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Mar 2013 15:40:24 -0400
Received: by mail-qe0-f74.google.com with SMTP id 7so360883qeb.3
        for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2013 12:40:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk, psusi@ubuntu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: loop-cleanup-partitions-when-detaching-loop-device-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     loop-cleanup-partitions-when-detaching-loop-device-checkpatch-fixes.patch

This patch was dropped because it was folded into loop-cleanup-partitions-when-detaching-loop-device.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: loop-cleanup-partitions-when-detaching-loop-device-checkpatch-fixes

ERROR: that open brace { should be on the previous line
#32: FILE: drivers/block/loop.c:1051:
+	if (bdev)
+	{

WARNING: line over 80 characters
#39: FILE: drivers/block/loop.c:1058:
+		disk_part_iter_init(&piter, bdev->bd_disk, DISK_PITER_INCL_EMPTY);

total: 1 errors, 1 warnings, 26 lines checked

./patches/loop-cleanup-partitions-when-detaching-loop-device.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Phillip Susi <psusi@ubuntu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/block/loop.c~loop-cleanup-partitions-when-detaching-loop-device-checkpatch-fixes drivers/block/loop.c
--- a/drivers/block/loop.c~loop-cleanup-partitions-when-detaching-loop-device-checkpatch-fixes
+++ a/drivers/block/loop.c
@@ -1048,8 +1048,7 @@ static int loop_clr_fd(struct loop_devic
 	if (!part_shift)
 		lo->lo_disk->flags |= GENHD_FL_NO_PART_SCAN;
 	mutex_unlock(&lo->lo_ctl_mutex);
-	if (bdev)
-	{
+	if (bdev) {
 		struct disk_part_iter piter;
 		struct hd_struct *part;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mips-define-kvm_user_mem_slots.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file.patch
timer_list-convert-timer-list-to-be-a-proper-seq_file-v3-fix.patch
loop-cleanup-partitions-when-detaching-loop-device.patch
loop-cleanup-partitions-when-detaching-loop-device-fix.patch
loop-cleanup-partitions-when-detaching-loop-device-fix-fix.patch
mm.patch
mm-shmemc-remove-an-ifdef.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module-fix.patch
memcg-relax-memcg-iter-caching-checkpatch-fixes.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix-fix.patch
kexec-vmalloc-export-additional-vmalloc-layer-information-fix.patch
mm-hugetlb-include-hugepages-in-meminfo-checkpatch-fixes.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
kernel-smpc-cleanups.patch
early_printk-consolidate-random-copies-of-identical-code-v3-fix.patch
include-linux-printkh-include-stdargh.patch
get_maintainer-use-filename-only-regex-match-for-tegra-fix.patch
argv_split-teach-it-to-handle-mutable-strings-fix.patch
epoll-trim-epitem-by-one-cache-line-on-x86_64-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix.patch
hfsplus-fix-warnings-in-fs-hfsplus-bfindc-in-function-hfs_find_1st_rec_by_cnid-fix.patch
usermodehelper-export-_exec-and-_setup-functions-fix.patch
kexec-use-min_t-to-simplify-logic-fix.patch
ipc-introduce-obtaining-a-lockless-ipc-object-fix.patch
ipcsem-open-code-and-rename-sem_lock-fix.patch
kernel-pidc-improve-flow-of-a-loop-inside-alloc_pidmap-fix.patch
pid_namespacec-h-simplify-defines-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
gadget-remove-only-user-of-aio-retry-checkpatch-fixes.patch
aio-remove-retry-based-aio-checkpatch-fixes.patch
aio-add-kiocb_cancel.patch
aio-make-aio_put_req-lockless-checkpatch-fixes.patch
aio-refcounting-cleanup-checkpatch-fixes.patch
wait-add-wait_event_hrtimeout.patch
aio-make-aio_read_evt-more-efficient-convert-to-hrtimers-checkpatch-fixes.patch
aio-use-cancellation-list-lazily.patch
aio-give-shared-kioctx-fields-their-own-cachelines.patch
generic-dynamic-per-cpu-refcounting.patch
generic-dynamic-per-cpu-refcounting-checkpatch-fixes.patch
aio-dont-include-aioh-in-schedh.patch
aio-kill-ki_retry.patch
aio-kill-ki_retry-checkpatch-fixes.patch
block-prep-work-for-batch-completion-checkpatch-fixes.patch
block-aio-batch-completion-for-bios-kiocbs.patch
block-aio-batch-completion-for-bios-kiocbs-checkpatch-fixes.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

