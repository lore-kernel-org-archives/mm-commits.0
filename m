From: akpm@linux-foundation.org
Subject: +
 ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch added to
 -mm tree
Date: Tue, 01 Dec 2015 16:50:42 -0800
Message-ID: <565e4062.A8vPbfA73UbbySfk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329AbbLBAun (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2015 19:50:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, ryan.ding@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix
has been added to the -mm tree.  Its filename is
     ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix

remove OCFS2_IOCB_UNALIGNED_IO, per Junxiao Bi

Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Ryan Ding <ryan.ding@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/ocfs2/aops.h~ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix fs/ocfs2/aops.h
--- a/fs/ocfs2/aops.h~ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix
+++ a/fs/ocfs2/aops.h
@@ -84,7 +84,6 @@ static inline void ocfs2_iocb_set_rw_loc
 enum ocfs2_iocb_lock_bits {
 	OCFS2_IOCB_RW_LOCK = 0,
 	OCFS2_IOCB_RW_LOCK_LEVEL,
-	OCFS2_IOCB_UNALIGNED_IO,
 	OCFS2_IOCB_NUM_LOCKS
 };
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
mm.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
mm-mmapc-remove-redundant-local-variables-for-may_expand_vm-fix.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
mm-mmap-add-new-proc-tunable-for-mmap_base-aslr-v5-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
ptrace-task_stopped_codeptrace-=-true-cant-see-task_stopped-task-fix.patch
fs-adfs-adfsh-tidy-up-comments.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

