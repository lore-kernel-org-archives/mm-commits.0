From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-pass-task-and-mm-to-do_madvise-fix-fix-fix.patch removed from -mm tree
Date: Wed, 29 Apr 2020 18:03:56 -0700
Message-ID: <20200430010356.sSo6rsI2D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbgD3BD5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 29 Apr 2020 21:03:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk, jannh@google.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-pass-task-and-mm-to-do_madvise-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-pass-task-and-mm-to-do_madvise-fix-fix-fix.patch

This patch was dropped because it was folded into mm-pass-task-and-mm-to-do_madvise.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-pass-task-and-mm-to-do_madvise-fix-fix-fix

whoops

Cc: Jann Horn <jannh@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/madvise.c~mm-pass-task-and-mm-to-do_madvise-fix-fix-fix
+++ a/mm/madvise.c
@@ -1109,7 +1109,7 @@ int do_madvise(struct task_struct *targe
 		 * model.
 		 */
 		if (!mmget_still_valid(mm)) {
-			up_write(mm->mmap_sem);
+			up_write(&mm->mmap_sem);
 			return -EINTR;
 		}
 	} else {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc-fix.patch
squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
mm-gupc-updating-the-documentation-fix.patch
mm-memcg-decouple-elowmin-state-mutations-from-protection-checks-fix.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
mm-add-debug_wx-support-fixpatch-added-to-mm-tree.patch
riscv-support-debug_wx-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-fix.patch
mm-pass-task-and-mm-to-do_madvise.patch
kernel-forkc-export-kernel_thread-to-modules.patch
