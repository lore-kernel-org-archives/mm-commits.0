From: akpm@linux-foundation.org
Subject: + mm-vmalloc-fix-a-typo-in-comment.patch added to -mm
 tree
Date: Sun, 05 Apr 2020 15:16:52 -0700
Message-ID: <20200405221652.4qug3P9AW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726887AbgDEWQx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 5 Apr 2020 18:16:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hqjagain@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: fix a typo in comment
has been added to the -mm tree.  Its filename is
     mm-vmalloc-fix-a-typo-in-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-fix-a-typo-in-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-fix-a-typo-in-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Qiujun Huang <hqjagain@gmail.com>
Subject: mm/vmalloc: fix a typo in comment

There is a typo in comment, fix it.
"exeeds" -> "exceeds"

Link: http://lkml.kernel.org/r/20200404060136.10838-1-hqjagain@gmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-a-typo-in-comment
+++ a/mm/vmalloc.c
@@ -3368,7 +3368,7 @@ retry:
 			goto overflow;
 
 		/*
-		 * If required width exeeds current VA block, move
+		 * If required width exceeds current VA block, move
 		 * base downwards and then recheck.
 		 */
 		if (base + end > va->va_end) {
_

Patches currently in -mm which might be from hqjagain@gmail.com are

mm-slab_common-fix-a-typo-in-comment-eariler-earlier.patch
mm-vmalloc-fix-a-typo-in-comment.patch
kmod-fix-a-typo-assuems-assumes.patch
lib-kconfigdebug-fix-a-typo-capabilitiy-capability.patch
