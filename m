From: akpm@linux-foundation.org
Subject: [merged] ksm-fix-the-comment-of-try_to_unmap_one.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:10:55 -0700
Message-ID: <201111012110.pA1LAtSC017348@hpaq5.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29156 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1KAVLB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:11:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gaowanlong@cn.fujitsu.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: fix the comment of try_to_unmap_one()
has been removed from the -mm tree.  Its filename was
     ksm-fix-the-comment-of-try_to_unmap_one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: ksm: fix the comment of try_to_unmap_one()

try_to_unmap_one() is called by try_to_unmap_ksm(), too.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/rmap.c~ksm-fix-the-comment-of-try_to_unmap_one mm/rmap.c
--- a/mm/rmap.c~ksm-fix-the-comment-of-try_to_unmap_one
+++ a/mm/rmap.c
@@ -1164,7 +1164,7 @@ void page_remove_rmap(struct page *page)
 
 /*
  * Subfunctions of try_to_unmap: try_to_unmap_one called
- * repeatedly from either try_to_unmap_anon or try_to_unmap_file.
+ * repeatedly from try_to_unmap_ksm, try_to_unmap_anon or try_to_unmap_file.
  */
 int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 		     unsigned long address, enum ttu_flags flags)
_

Patches currently in -mm which might be from gaowanlong@cn.fujitsu.com are

origin.patch
linux-next.patch

