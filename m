From: akpm@linux-foundation.org
Subject: + mm-vma_adjust-minor-comment-correction.patch added to -mm tree
Date: Tue, 27 Sep 2016 13:00:39 -0700
Message-ID: <57eacfe7.XiuIVnBKEQyNxouJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45277 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934098AbcI0UAk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 27 Sep 2016 16:00:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, hughd@google.com, janvorli@microsoft.com, mgorman@techsingularity.net, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vma_adjust: minor comment correction
has been added to the -mm tree.  Its filename is
     mm-vma_adjust-minor-comment-correction.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vma_adjust-minor-comment-correction.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vma_adjust-minor-comment-correction.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -662,7 +662,7 @@ int __vma_adjust(struct vm_area_struct *
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

mm-vm_page_prot-update-with-write_once-read_once.patch
mm-vma_adjust-remove-superfluous-confusing-update-in-remove_next-==-1-case.patch
mm-vma_merge-fix-vm_page_prot-smp-race-condition-against-rmap_walk.patch
mm-vma_adjust-remove-superfluous-check-for-next-not-null.patch
mm-vma_adjust-minor-comment-correction.patch
mm-vma_merge-correct-false-positive-from-__vma_unlink-validate_mm_rb.patch

