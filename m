From: akpm@linux-foundation.org
Subject: [folded-merged] thp-implement-splitting-pmd-for-huge-zero-page-fix.patch removed from -mm tree
Date: Wed, 12 Dec 2012 13:36:40 -0800
Message-ID: <20121212213641.6C5C120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f201.google.com ([209.85.215.201]:45100 "EHLO
	mail-ea0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737Ab2LLVgn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 16:36:43 -0500
Received: by mail-ea0-f201.google.com with SMTP id b14so67124eaa.0
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 13:36:42 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp-implement-splitting-pmd-for-huge-zero-page-fix
has been removed from the -mm tree.  Its filename was
     thp-implement-splitting-pmd-for-huge-zero-page-fix.patch

This patch was dropped because it was folded into thp-implement-splitting-pmd-for-huge-zero-page.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: thp-implement-splitting-pmd-for-huge-zero-page-fix

fix build error

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/huge_memory.c~thp-implement-splitting-pmd-for-huge-zero-page-fix mm/huge_memory.c
--- a/mm/huge_memory.c~thp-implement-splitting-pmd-for-huge-zero-page-fix
+++ a/mm/huge_memory.c
@@ -2672,7 +2672,6 @@ void __split_huge_page_pmd(struct vm_are
 	struct page *page;
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long haddr = address & HPAGE_PMD_MASK;
-	struct mm_struct *mm = vma->vm_mm;
 	unsigned long mmun_start;	/* For mmu_notifiers */
 	unsigned long mmun_end;		/* For mmu_notifiers */
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
thp-implement-splitting-pmd-for-huge-zero-page.patch
mm-add-a-reminder-comment-for-__gfp_bits_shift.patch
numa-add-config_movable_node-for-movable-dedicated-node-fix.patch
mm-introduce-new-field-managed_pages-to-struct-zone-fix.patch
mm-provide-more-accurate-estimation-of-pages-occupied-by-memmap-fix.patch
tmpfs-support-seek_data-and-seek_hole-reprise.patch
hwpoison-hugetlbfs-fix-rss-counter-warning-fix.patch
hwpoison-hugetlbfs-fix-rss-counter-warning-fix-fix.patch
mm-memoryc-remove-unused-code-from-do_wp_page-fix.patch

