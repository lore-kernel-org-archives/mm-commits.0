From: akpm@linux-foundation.org
Subject: [merged] thp-fix-comments-of-__pmd_trans_huge_lock.patch removed
 from -mm tree
Date: Wed, 27 Jul 2016 12:03:34 -0700
Message-ID: <57990586.Jqj9jUVgTPduIXK9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190AbcG0TDf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:03:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: fix comments of __pmd_trans_huge_lock()
has been removed from the -mm tree.  Its filename was
     thp-fix-comments-of-__pmd_trans_huge_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: thp: fix comments of __pmd_trans_huge_lock()

To make the comments consistent with the already changed code.

Link: http://lkml.kernel.org/r/1466200004-6196-1-git-send-email-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/huge_memory.c~thp-fix-comments-of-__pmd_trans_huge_lock mm/huge_memory.c
--- a/mm/huge_memory.c~thp-fix-comments-of-__pmd_trans_huge_lock
+++ a/mm/huge_memory.c
@@ -1458,10 +1458,10 @@ int change_huge_pmd(struct vm_area_struc
 }
 
 /*
- * Returns true if a given pmd maps a thp, false otherwise.
+ * Returns page table lock pointer if a given pmd maps a thp, NULL otherwise.
  *
- * Note that if it returns true, this routine returns without unlocking page
- * table lock. So callers must unlock it.
+ * Note that if it returns page table lock pointer, this routine returns without
+ * unlocking page table lock. So callers must unlock it.
  */
 spinlock_t *__pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma)
 {
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-thp-clean-up-return-value-of-madvise_free_huge_pmd.patch

