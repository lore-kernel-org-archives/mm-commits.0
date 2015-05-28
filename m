From: akpm@linux-foundation.org
Subject: + mm-cma-fix-for-typos-in-comments.patch added to -mm tree
Date: Thu, 28 May 2015 14:14:29 -0700
Message-ID: <55678535.F3mGzAjKyw67luRw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59316 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932527AbbE1VOa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 May 2015 17:14:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shailendra.capricorn@gmail.com, mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma.c: fix typos in comments
has been added to the -mm tree.  Its filename is
     mm-cma-fix-for-typos-in-comments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-fix-for-typos-in-comments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-fix-for-typos-in-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shailendra Verma <shailendra.capricorn@gmail.com>
Subject: mm/cma.c: fix typos in comments

Signed-off-by: Shailendra Verma <shailendra.capricorn@gmail.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/cma.c~mm-cma-fix-for-typos-in-comments mm/cma.c
--- a/mm/cma.c~mm-cma-fix-for-typos-in-comments
+++ a/mm/cma.c
@@ -182,7 +182,7 @@ int __init cma_init_reserved_mem(phys_ad
 	if (!size || !memblock_is_region_reserved(base, size))
 		return -EINVAL;
 
-	/* ensure minimal alignment requied by mm core */
+	/* ensure minimal alignment required by mm core */
 	alignment = PAGE_SIZE << max(MAX_ORDER - 1, pageblock_order);
 
 	/* alignment should be aligned with order_per_bit */
@@ -238,7 +238,7 @@ int __init cma_declare_contiguous(phys_a
 	/*
 	 * high_memory isn't direct mapped memory so retrieving its physical
 	 * address isn't appropriate.  But it would be useful to check the
-	 * physical address of the highmem boundary so it's justfiable to get
+	 * physical address of the highmem boundary so it's justifiable to get
 	 * the physical address from it.  On x86 there is a validation check for
 	 * this case, so the following workaround is needed to avoid it.
 	 */
_

Patches currently in -mm which might be from shailendra.capricorn@gmail.com are

mm-cma-fix-for-typos-in-comments.patch
linux-next.patch

