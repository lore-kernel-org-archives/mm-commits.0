From: akpm@linux-foundation.org
Subject: [folded-merged]
 x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
 removed from -mm tree
Date: Thu, 14 Nov 2013 14:21:41 -0800
Message-ID: <52854cf5.juwKUIHpiWqYLsLY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52528 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757967Ab3KNWVm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Nov 2013 17:21:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com, akpm@linux-foundation.org

Subject: [folded-merged] x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,kirill.shutemov@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 14 Nov 2013 14:21:41 -0800


The patch titled
     Subject: x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch

This patch was dropped because it was folded into x86-mm-enable-split-page-table-lock-for-pmd-level.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes

ERROR: need consistent spacing around '|' (ctx:VxW)
#62: FILE: arch/x86/include/asm/pgalloc.h:84:
+	page = alloc_pages(GFP_KERNEL | __GFP_REPEAT| __GFP_ZERO, 0);
 	                                            ^

total: 1 errors, 0 warnings, 32 lines checked

./patches/x86-mm-enable-split-page-table-lock-for-pmd-level.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgalloc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/include/asm/pgalloc.h~x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes arch/x86/include/asm/pgalloc.h
--- a/arch/x86/include/asm/pgalloc.h~x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes
+++ a/arch/x86/include/asm/pgalloc.h
@@ -81,7 +81,7 @@ static inline void pmd_populate(struct m
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long addr)
 {
 	struct page *page;
-	page = alloc_pages(GFP_KERNEL | __GFP_REPEAT| __GFP_ZERO, 0);
+	page = alloc_pages(GFP_KERNEL | __GFP_REPEAT | __GFP_ZERO, 0);
 	if (!page)
 		return NULL;
 	if (!pgtable_pmd_page_ctor(page)) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-memstick-core-ms_blockc-fix-spelling-in-msb_rp_recive_status_reg.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
x86-mm-enable-split-page-table-lock-for-pmd-level.patch
tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch
kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix.patch
llists-move-llist_reverse_order-from-raid5-to-llistc-fix.patch
kfifo-api-type-safety-checkpatch-fixes.patch

