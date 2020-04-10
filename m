From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-memory_hotplug-fix-a-typo-in-comment-recoreded-recorded.patch added to
 -mm tree
Date: Fri, 10 Apr 2020 11:38:31 -0700
Message-ID: <20200410183831.62AAAuqka%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726177AbgDJSid (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 14:38:33 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ethp@qq.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug: Fix a typo in comment "recoreded"->"recorded"
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-fix-a-typo-in-comment-recoreded-recorded.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-fix-a-typo-in-comment-recoreded-recorded.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-fix-a-typo-in-comment-recoreded-recorded.patch

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
Subject: mm/memory_hotplug: Fix a typo in comment "recoreded"->"recorded"

There is a typo in comment, fix it.
s/recoreded/recorded

Link: http://lkml.kernel.org/r/20200410160328.13843-1-ethp@qq.com
Signed-off-by: Ethon Paul <ethp@qq.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory_hotplug.c~mm-memory_hotplug-fix-a-typo-in-comment-recoreded-recorded
+++ a/mm/memory_hotplug.c
@@ -1357,7 +1357,7 @@ offline_isolated_pages_cb(unsigned long
 }
 
 /*
- * Check all pages in range, recoreded as memory resource, are isolated.
+ * Check all pages in range, recorded as memory resource, are isolated.
  */
 static int
 check_pages_isolated_cb(unsigned long start_pfn, unsigned long nr_pages,
_

Patches currently in -mm which might be from ethp@qq.com are

mm-memory_hotplug-fix-a-typo-in-comment-recoreded-recorded.patch
mm-ksm-fix-a-typo-in-comment-alreaady-already.patch
mm-mmap-fix-a-typo-in-comment-compatbility-compatibility.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained.patch
