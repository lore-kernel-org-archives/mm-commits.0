From: akpm@linux-foundation.org
Subject: [merged] mm-fix-typo-in-comment-in-do_fault_around.patch removed
 from -mm tree
Date: Thu, 05 Jun 2014 12:53:15 -0700
Message-ID: <5390caab.+zK7AjB2qPYSobBM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56559 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbaFETxP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:53:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com

Subject: [merged] mm-fix-typo-in-comment-in-do_fault_around.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:53:15 -0700


The patch titled
     Subject: mm: fix typo in comment in do_fault_around()
has been removed from the -mm tree.  Its filename was
     mm-fix-typo-in-comment-in-do_fault_around.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: fix typo in comment in do_fault_around()

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~mm-fix-typo-in-comment-in-do_fault_around mm/memory.c
--- a/mm/memory.c~mm-fix-typo-in-comment-in-do_fault_around
+++ a/mm/memory.c
@@ -2832,7 +2832,7 @@ static void do_fault_around(struct vm_ar
 
 	/*
 	 *  max_pgoff is either end of page table or end of vma
-	 *  or fault_around_pages() from pgoff, depending what is neast.
+	 *  or fault_around_pages() from pgoff, depending what is nearest.
 	 */
 	max_pgoff = pgoff - ((start_addr >> PAGE_SHIFT) & (PTRS_PER_PTE - 1)) +
 		PTRS_PER_PTE - 1;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-update-page-table-walker-core-fix.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-prom-pid-clear_refs-avoid-split_huge_page.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch
mm-mark-remap_file_pages-syscall-as-deprecated.patch
mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-2.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

