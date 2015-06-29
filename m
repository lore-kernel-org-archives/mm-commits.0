From: akpm@linux-foundation.org
Subject: [merged] mm-cma-fix-for-typos-in-comments.patch removed from -mm
 tree
Date: Mon, 29 Jun 2015 13:38:57 -0700
Message-ID: <5591ace1.TrW7MDKyTCAHyQ0z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50499 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbbF2Ui5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:38:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shailendra.capricorn@gmail.com, mina86@mina86.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/cma.c: fix typos in comments
has been removed from the -mm tree.  Its filename was
     mm-cma-fix-for-typos-in-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

