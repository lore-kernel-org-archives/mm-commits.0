From: akpm@linux-foundation.org
Subject: [merged] mm-vma_adjust-minor-comment-correction.patch removed
 from -mm tree
Date: Mon, 10 Oct 2016 15:46:18 -0700
Message-ID: <57fc1a3a.oP60wRZHYSyUU13K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37245 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752286AbcJJWqT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2016 18:46:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, janvorli@microsoft.com, mgorman@techsingularity.net, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vma_adjust: minor comment correction
has been removed from the -mm tree.  Its filename was
     mm-vma_adjust-minor-comment-correction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: vma_adjust: minor comment correction

The cases are three not two.

Link: http://lkml.kernel.org/r/1474492522-2261-3-git-send-email-aarcange@redhat.com
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Jan Vorlicek <janvorli@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~mm-vma_adjust-minor-comment-correction mm/mmap.c
--- a/mm/mmap.c~mm-vma_adjust-minor-comment-correction
+++ a/mm/mmap.c
@@ -667,7 +667,7 @@ int __vma_adjust(struct vm_area_struct *
 			/*
 			 * vma expands, overlapping all the next, and
 			 * perhaps the one after too (mprotect case 6).
-			 * The only two other cases that gets here are
+			 * The only other cases that gets here are
 			 * case 1, case 7 and case 8.
 			 */
 			if (next == expand) {
_

Patches currently in -mm which might be from aarcange@redhat.com are


