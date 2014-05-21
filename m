From: akpm@linux-foundation.org
Subject: + mm-fix-typo-in-comment-in-do_fault_around.patch added to -mm
 tree
Date: Wed, 21 May 2014 13:34:41 -0700
Message-ID: <537d0de1.Cx0YKa+CxEQ9h+3E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49133 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbaEUUel (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 May 2014 16:34:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com

Subject: + mm-fix-typo-in-comment-in-do_fault_around.patch added to -mm tree
To: kirill.shutemov@linux.intel.com
From: akpm@linux-foundation.org
Date: Wed, 21 May 2014 13:34:41 -0700


The patch titled
     Subject: mm: fix typo in comment in do_fault_around()
has been added to the -mm tree.  Its filename is
     mm-fix-typo-in-comment-in-do_fault_around.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-typo-in-comment-in-do_fault_around.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-typo-in-comment-in-do_fault_around.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-fix-typo-in-comment-in-do_fault_around.patch
pagewalk-update-page-table-walker-core.patch
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
thp-consolidate-assert-checks-in-__split_huge_page.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
mm-pass-vm_bug_on-reason-to-dump_page.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
mm-swapc-introduce-put_refcounted_compound_page-helpers-for-spliting-put_compound_page.patch
mm-swapc-split-put_compound_page-function.patch
mm-introdule-compound_head_by_tail.patch
mm-move-get_user_pages-related-code-to-separate-file.patch
mm-extract-in_gate_area-case-from-__get_user_pages.patch
mm-cleanup-follow_page_mask.patch
mm-extract-code-to-fault-in-a-page-from-__get_user_pages.patch
mm-cleanup-__get_user_pages.patch
mm-rmapc-make-page_referenced_one-and-try_to_unmap_one-static.patch
mm-update-comment-for-default_max_map_count.patch
mm-update-comment-for-default_max_map_count-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-userc-drop-unused-field-files-from-user_struct.patch
linux-next.patch
mm-mark-remap_file_pages-syscall-as-deprecated.patch
mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-2.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix-3.patch

