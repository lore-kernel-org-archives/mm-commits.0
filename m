From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 =?US-ASCII?Q?mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-ch?=
 =?US-ASCII?Q?eckpatch-fixes.patch?= added to -mm tree
Date: Tue, 14 Apr 2020 16:11:23 -0700
Message-ID: <20200414231123.jz-Qa44ra%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441019AbgDNXLZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Apr 2020 19:11:25 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ethp@qq.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com


The patch titled
     Subject: mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes

WARNING: line over 80 characters
#65: FILE: mm/hugetlb.c:4469:
+	 * an active hugepage in pagecache. This goto expects the 2nd page fault,

total: 0 errors, 1 warnings, 48 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Ethon Paul <ethp@qq.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes
+++ a/mm/hugetlb.c
@@ -4466,9 +4466,9 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	/*
 	 * entry could be a migration/hwpoison entry at this point, so this
 	 * check prevents the kernel from going below assuming that we have
-	 * an active hugepage in pagecache. This goto expects the 2nd page fault,
-	 * and is_hugetlb_entry_(migration|hwpoisoned) check will properly
-	 * handle it.
+	 * an active hugepage in pagecache. This goto expects the 2nd page
+	 * fault, and is_hugetlb_entry_(migration|hwpoisoned) check will
+	 * properly handle it.
 	 */
 	if (!pte_present(entry))
 		goto out_mutex;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

maintainers-add-an-entry-for-kfifo-fix.patch
maintainers-add-an-entry-for-kfifo-fix-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
linux-next-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
