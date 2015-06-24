From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger-fix.patch removed from -mm tree
Date: Wed, 24 Jun 2015 16:43:35 -0700
Message-ID: <558b40a7.TxiUYYxh8Q6stGyH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbbFXXng (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jun 2015 19:43:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger-fix
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger-fix.patch

This patch was dropped because it was folded into ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger-fix

update comment, per Joseph

Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Xue jiufei <xuejiufei@huawei.com>
Cc: joyce.xue <xuejiufei@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/ocfs2/journal.c~ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger-fix fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger-fix
+++ a/fs/ocfs2/journal.c
@@ -571,8 +571,6 @@ static void ocfs2_abort_trigger(struct j
 	     (unsigned long)bh,
 	     (unsigned long long)bh->b_blocknr);
 
-	/* We aren't guaranteed to have the superblock here - but if we
-	 * don't, it'll just crash. */
 	ocfs2_error(bh->b_bdev->bd_super,
 		    "JBD2 has aborted our journal, ocfs2 cannot continue\n");
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ocfs2-reduce-object-size-of-mlog-uses.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-fix-null-pointer-dereference-in-function-ocfs2_abort_trigger.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix.patch
hugetlb-do-not-account-hugetlb-pages-as-nr_file_pages-fix.patch
mm-do-not-ignore-mapping_gfp_mask-in-page-cache-allocation-paths-checkpatch-fixes.patch

