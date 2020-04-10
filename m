From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-fix-a-typo-in-comment-alreaady-already.patch
 added to -mm tree
Date: Fri, 10 Apr 2020 11:38:33 -0700
Message-ID: <20200410183833.Mr60GYBtJ%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726203AbgDJSid (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 14:38:33 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ethp@qq.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: ksm: Fix a typo in comment "alreaady"->"already"
has been added to the -mm tree.  Its filename is
     mm-ksm-fix-a-typo-in-comment-alreaady-already.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-ksm-fix-a-typo-in-comment-alreaady-already.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-ksm-fix-a-typo-in-comment-alreaady-already.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ethon Paul <ethp@qq.com>
Subject: mm: ksm: Fix a typo in comment "alreaady"->"already"

There is a typo in comment, fix it.

Link: http://lkml.kernel.org/r/20200410162427.13927-1-ethp@qq.com
Signed-off-by: Ethon Paul <ethp@qq.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/ksm.c~mm-ksm-fix-a-typo-in-comment-alreaady-already
+++ a/mm/ksm.c
@@ -1148,7 +1148,7 @@ static int replace_page(struct vm_area_s
 
 	/*
 	 * No need to check ksm_use_zero_pages here: we can only have a
-	 * zero_page here if ksm_use_zero_pages was enabled alreaady.
+	 * zero_page here if ksm_use_zero_pages was enabled already.
 	 */
 	if (!is_zero_pfn(page_to_pfn(kpage))) {
 		get_page(kpage);
_

Patches currently in -mm which might be from ethp@qq.com are

mm-memory_hotplug-fix-a-typo-in-comment-recoreded-recorded.patch
mm-ksm-fix-a-typo-in-comment-alreaady-already.patch
mm-mmap-fix-a-typo-in-comment-compatbility-compatibility.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained.patch
