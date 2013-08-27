From: akpm@linux-foundation.org
Subject: [folded-merged]
 ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2.patch removed from -mm tree
Date: Tue, 27 Aug 2013 14:03:00 -0700
Message-ID: <521d1404.yW9UMM8U38uS/VW6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab3H0VDB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Aug 2013 17:03:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sunil.mushran@gmail.com, shencanquan@huawei.com, mfasheh@suse.com, jlbec@evilplan.org, jeff.liu@oracle.com, younger.liu@huawei.com

Subject: [folded-merged] ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2.patch removed from -mm tree
To: younger.liu@huawei.com,jeff.liu@oracle.com,jlbec@evilplan.org,mfasheh@suse.com,shencanquan@huawei.com,sunil.mushran@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 27 Aug 2013 14:03:00 -0700


The patch titled
     Subject: ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2.patch

This patch was dropped because it was folded into ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch

------------------------------------------------------
From: Younger Liu <younger.liu@huawei.com>
Subject: ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2

Compared with PATCH V1, bug description is updated, and pointless comments
are removed.

Signed-off-by: Younger Liu <younger.liu@huawei.com>
Cc: Jie Liu <jeff.liu@oracle.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Sunil Mushran <sunil.mushran@gmail.com>
Cc: Jensen <shencanquan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/ocfs2/file.c~ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2 fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size-v2
+++ a/fs/ocfs2/file.c
@@ -474,8 +474,6 @@ static int ocfs2_truncate_file(struct in
 		goto bail;
 	}
 
-	/* lets handle the simple truncate cases before doing any more
-	 * cluster locking. */
 	down_write(&OCFS2_I(inode)->ip_alloc_sem);
 
 	ocfs2_resv_discard(&osb->osb_la_resmap,
_

Patches currently in -mm which might be from younger.liu@huawei.com are

ocfs2-should-call-ocfs2_journal_access_di-before-ocfs2_delete_entry-in-ocfs2_orphan_del.patch
ocfs2-fix-issue-that-ocfs2_setattr-does-not-deal-with-new_i_size==i_size.patch
ocfs2-update-inode-size-after-zeronig-the-hole.patch
ocfs2-lighten-up-allocate-transaction.patch
ocfs2-ac_bits_wanted-should-be-local_alloc_bits-when-returns-enospc.patch
ocfs2-fix-a-memory-leak-in-__ocfs2_move_extents.patch
ocfs2-free-meta_ac-and-data_ac-when-ocfs2_start_trans-fails-in-ocfs2_xattr_set.patch
ocfs2-free-path-in-ocfs2_remove_inode_range.patch
linux-next.patch

