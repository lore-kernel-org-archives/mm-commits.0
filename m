From: akpm@linux-foundation.org
Subject: + mm-remove-extra-newline-from-allocation-stall-warning-fix.patch added to -mm tree
Date: Mon, 07 Nov 2016 13:47:37 -0800
Message-ID: <5820f679.Lb4Ab+N7Gs/GxJYE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37746 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751244AbcKGVrn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2016 16:47:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-remove-extra-newline-from-allocation-stall-warning-fix
has been added to the -mm tree.  Its filename is
     mm-remove-extra-newline-from-allocation-stall-warning-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-extra-newline-from-allocation-stall-warning-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-extra-newline-from-allocation-stall-warning-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: mm-remove-extra-newline-from-allocation-stall-warning-fix

fix typo

Link: http://lkml.kernel.org/r/1476026219-7974-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-remove-extra-newline-from-allocation-stall-warning-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-extra-newline-from-allocation-stall-warning-fix
+++ a/mm/page_alloc.c
@@ -3658,7 +3658,7 @@ retry:
 	/* Make sure we know about allocations which stall for too long */
 	if (time_after(jiffies, alloc_start + stall_timeout)) {
 		warn_alloc(gfp_mask,
-			"page alloction stalls for %ums, order:%u",
+			"page allocation stalls for %ums, order:%u",
 			jiffies_to_msecs(jiffies-alloc_start), order);
 		stall_timeout += 10 * HZ;
 	}
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

mm-remove-extra-newline-from-allocation-stall-warning.patch
mm-remove-extra-newline-from-allocation-stall-warning-fix.patch
hung_task-decrement-sysctl_hung_task_warnings-only-if-it-is-positive.patch

