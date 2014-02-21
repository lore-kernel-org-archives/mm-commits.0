From: akpm@linux-foundation.org
Subject: + mm-memoryc-update-comment-in-unmap_single_vma.patch added to
 -mm tree
Date: Fri, 21 Feb 2014 12:48:55 -0800
Message-ID: <5307bbb7.X002NtdZd1ENOo3N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58332 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbaBUUsz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 15:48:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, davidlohr@hp.com

Subject: + mm-memoryc-update-comment-in-unmap_single_vma.patch added to -mm tree
To: davidlohr@hp.com
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 12:48:55 -0800


The patch titled
     Subject: mm/memory.c: update comment in unmap_single_vma()
has been added to the -mm tree.  Its filename is
     mm-memoryc-update-comment-in-unmap_single_vma.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memoryc-update-comment-in-unmap_single_vma.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memoryc-update-comment-in-unmap_single_vma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: mm/memory.c: update comment in unmap_single_vma()

The described issue now occurs inside mmap_region().  And unfortunately is
still valid.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory.c~mm-memoryc-update-comment-in-unmap_single_vma mm/memory.c
--- a/mm/memory.c~mm-memoryc-update-comment-in-unmap_single_vma
+++ a/mm/memory.c
@@ -1320,9 +1320,9 @@ static void unmap_single_vma(struct mmu_
 			 * It is undesirable to test vma->vm_file as it
 			 * should be non-null for valid hugetlb area.
 			 * However, vm_file will be NULL in the error
-			 * cleanup path of do_mmap_pgoff. When
+			 * cleanup path of mmap_region. When
 			 * hugetlbfs ->mmap method fails,
-			 * do_mmap_pgoff() nullifies vma->vm_file
+			 * mmap_region() nullifies vma->vm_file
 			 * before calling this function to clean up.
 			 * Since no pte has actually been setup, it is
 			 * safe to do nothing in this case.
_

Patches currently in -mm which might be from davidlohr@hp.com are

ipcmqueue-remove-limits-for-the-amount-of-system-wide-queues.patch
mm-hugetlb-unify-region-structure-handling.patch
mm-hugetlb-improve-cleanup-resv_map-parameters.patch
mm-hugetlb-fix-race-in-region-tracking.patch
mm-hugetlb-remove-resv_map_put.patch
mm-hugetlb-use-vma_resv_map-map-types.patch
mm-hugetlb-improve-page-fault-scalability.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-hugetlb-mark-some-bootstrap-functions-as-__init.patch
mm-memoryc-update-comment-in-unmap_single_vma.patch
ipccompat-remove-sc_semopm-macro.patch
ipc-use-device_initcall.patch
linux-next.patch

