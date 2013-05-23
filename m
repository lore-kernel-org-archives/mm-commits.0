From: akpm@linux-foundation.org
Subject: [folded-merged]
 block-prep-work-for-batch-completion-fix-3-fix.patch removed from -mm tree
Date: Thu, 23 May 2013 13:49:13 -0700
Message-ID: <519e80c9.5EbeAM1RbAqjkXsK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49863 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758494Ab3EWUtO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 May 2013 16:49:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, neilb@suse.de, koverstreet@google.com, fengguang.wu@intel.com, akpm@linux-foundation.org

Subject: [folded-merged] block-prep-work-for-batch-completion-fix-3-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,fengguang.wu@intel.com,koverstreet@google.com,neilb@suse.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 May 2013 13:49:13 -0700


The patch titled
     Subject: block-prep-work-for-batch-completion-fix-3-fix
has been removed from the -mm tree.  Its filename was
     block-prep-work-for-batch-completion-fix-3-fix.patch

This patch was dropped because it was folded into block-prep-work-for-batch-completion.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: block-prep-work-for-batch-completion-fix-3-fix

Cc: Kent Overstreet <koverstreet@google.com>
Cc: Neil Brown <neilb@suse.de>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/bcache/alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/md/bcache/alloc.c~block-prep-work-for-batch-completion-fix-3-fix drivers/md/bcache/alloc.c
--- a/drivers/md/bcache/alloc.c~block-prep-work-for-batch-completion-fix-3-fix
+++ a/drivers/md/bcache/alloc.c
@@ -156,7 +156,8 @@ static void discard_finish(struct work_s
 	closure_put(&ca->set->cl);
 }
 
-static void discard_endio(struct bio *bio, int error)
+static void discard_endio(struct bio *bio, int error,
+			  struct batch_complete *batch)
 {
 	struct discard *d = container_of(bio, struct discard, bio);
 	schedule_work(&d->work);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
revert-selftest-add-simple-test-for-soft-dirty-bit.patch
kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg-fix.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory-fix.patch
memory_hotplug-use-pgdat_resize_lock-in-__offline_pages-fix.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
dump_stack-serialize-the-output-from-dump_stack-fix.patch
panic-add-cpu-pid-to-warn_slowpath_common-in-warning-printks-fix.patch
lib-bitmapc-speed-up-bitmap_find_free_region-fix.patch
rbtree-remove-unneeded-include-fix.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
partitions-add-aix-lvm-partition-support-files-checkpatch-fixes.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
generic-dynamic-per-cpu-refcounting.patch
block-prep-work-for-batch-completion.patch
block-prep-work-for-batch-completion-fix-99.patch
block-prep-work-for-batch-completion-fix-4.patch
block-prep-work-for-batch-completion-fix-101.patch
block-aio-batch-completion-for-bios-kiocbs.patch
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

