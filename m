From: akpm@linux-foundation.org
Subject: + mm-memory-failure-fix-the-typo-in-me_pagecache_dirty.patch
 added to -mm tree
Date: Fri, 22 Nov 2013 14:57:44 -0800
Message-ID: <528fe168.6VcUC3gEsvmn/YzA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58216 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200Ab3KVW5p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Nov 2013 17:57:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, wuzhy@linux.vnet.ibm.com

Subject: + mm-memory-failure-fix-the-typo-in-me_pagecache_dirty.patch added to -mm tree
To: wuzhy@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Fri, 22 Nov 2013 14:57:44 -0800


The patch titled
     Subject: mm, memory-failure: fix typo in me_pagecache_dirty()
has been added to the -mm tree.  Its filename is
     mm-memory-failure-fix-the-typo-in-me_pagecache_dirty.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failure-fix-the-typo-in-me_pagecache_dirty.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failure-fix-the-typo-in-me_pagecache_dirty.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: mm, memory-failure: fix typo in me_pagecache_dirty()

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory-failure.c~mm-memory-failure-fix-the-typo-in-me_pagecache_dirty mm/memory-failure.c
--- a/mm/memory-failure.c~mm-memory-failure-fix-the-typo-in-me_pagecache_dirty
+++ a/mm/memory-failure.c
@@ -611,7 +611,7 @@ static int me_pagecache_clean(struct pag
 }
 
 /*
- * Dirty cache page page
+ * Dirty cache page
  * Issues: when the error hit a hole page the error is not properly
  * propagated.
  */
_

Patches currently in -mm which might be from wuzhy@linux.vnet.ibm.com are

origin.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty.patch
linux-next.patch

