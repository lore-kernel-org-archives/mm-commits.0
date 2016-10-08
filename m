From: akpm@linux-foundation.org
Subject: [patch 094/127] mm: vma_adjust: minor comment correction
Date: Fri, 07 Oct 2016 17:01:34 -0700
Message-ID: <57f8375e.kCHP5u1oWSMSErXu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39462 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932764AbcJHABf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:01:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aarcange@redhat.com, hughd@google.com, janvorli@microsoft.com, mgorman@techsingularity.net, riel@redhat.com

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
