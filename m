From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-fix-slot-overwritten-if-storage-link-down-during-mount-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 14 Jan 2016 14:18:18 -0800
Message-ID: <56981eaa.nrxwKG3cdRdyt5cs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44002 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbcANWSS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:18:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jiangyiwen@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-fix-slot-overwritten-if-storage-link-down-during-mount-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-slot-overwritten-if-storage-link-down-during-mount-checkpatch-fixes.patch

This patch was dropped because it was folded into ocfs2-fix-slot-overwritten-if-storage-link-down-during-mount.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ocfs2-fix-slot-overwritten-if-storage-link-down-during-mount-checkpatch-fixes

WARNING: line over 80 characters
#52: FILE: fs/ocfs2/slot_map.c:508:
+		 * if write block failed, invalidate slot to avoid overwrite slot during

total: 0 errors, 1 warnings, 18 lines checked

./patches/ocfs2-fix-slot-overwritten-if-storage-link-down-during-mount.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Yiwen Jiang <jiangyiwen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/slot_map.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/slot_map.c~ocfs2-fix-slot-overwritten-if-storage-link-down-during-mount-checkpatch-fixes fs/ocfs2/slot_map.c
--- a/fs/ocfs2/slot_map.c~ocfs2-fix-slot-overwritten-if-storage-link-down-during-mount-checkpatch-fixes
+++ a/fs/ocfs2/slot_map.c
@@ -505,8 +505,8 @@ int ocfs2_find_slot(struct ocfs2_super *
 	if (status < 0) {
 		mlog_errno(status);
 		/*
-		 * if write block failed, invalidate slot to avoid overwrite slot during
-		 * dismount in case another node rightly has mounted
+		 * if write block failed, invalidate slot to avoid overwrite
+		 * slot during dismount in case another node rightly has mounted
 		 */
 		spin_lock(&osb->osb_lock);
 		ocfs2_invalidate_slot(si, osb->slot_num);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ocfs2-fix-slot-overwritten-if-storage-link-down-during-mount.patch
include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
account-certain-kmem-allocations-to-memcg-checkpatch-fixes.patch
include-define-__phys_to_pfn-as-phys_pfn-fix.patch
mempolicy-convert-the-shared_policy-lock-to-a-rwlock-fix-2.patch
mm-zonelist-enumerate-zonelists-array-index-checkpatch-fixes.patch
mm-zonelist-enumerate-zonelists-array-index-fix.patch
mm-get-rid-of-__alloc_pages_high_priority-checkpatch-fixes.patch
mm-vmalloc-remove-vm_vpages-fix.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
arm64-mm-support-arch_mmap_rnd_bits-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
thp-reintroduce-split_huge_page-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
thp-add-debugfs-handle-to-split-all-huge-pages-fix.patch

