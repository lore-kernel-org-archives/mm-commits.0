From: akpm@linux-foundation.org
Subject: + mm-slub-fix-typo.patch added to -mm tree
Date: Tue, 20 Jan 2015 16:08:17 -0800
Message-ID: <54beedf1.sQwuVqJ4Lv+v9iOF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48529 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbbAUAIS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 Jan 2015 19:08:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kim.phillips@freescale.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub.c: fix typo in comment
has been added to the -mm tree.  Its filename is
     mm-slub-fix-typo.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-fix-typo.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-fix-typo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kim Phillips <kim.phillips@freescale.com>
Subject: mm/slub.c: fix typo in comment

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~mm-slub-fix-typo mm/slub.c
--- a/mm/slub.c~mm-slub-fix-typo
+++ a/mm/slub.c
@@ -2521,7 +2521,7 @@ EXPORT_SYMBOL(kmem_cache_alloc_node_trac
 #endif
 
 /*
- * Slow patch handling. This may still be called frequently since objects
+ * Slow path handling. This may still be called frequently since objects
  * have a longer lifetime than the cpu slabs in most processing loads.
  *
  * So we still attempt to reduce cache line usage. Just take the slab
_

Patches currently in -mm which might be from kim.phillips@freescale.com are

mm-slub-fix-typo.patch

