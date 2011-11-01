From: akpm@linux-foundation.org
Subject: [merged] mm-memblock-small-function-definition-fixes.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:10:43 -0700
Message-ID: <201111012110.pA1LAhRL004948@wpaz13.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15743 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705Ab1KAVKw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:10:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhbird.choi@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: small function definition fixes
has been removed from the -mm tree.  Its filename was
     mm-memblock-small-function-definition-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jonghwan Choi <jhbird.choi@samsung.com>
Subject: mm/memblock.c: small function definition fixes

warning: function 'memblock_memory_can_coalesce'
with external linkage has definition.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memblock.c~mm-memblock-small-function-definition-fixes mm/memblock.c
--- a/mm/memblock.c~mm-memblock-small-function-definition-fixes
+++ a/mm/memblock.c
@@ -267,7 +267,7 @@ static int __init_memblock memblock_doub
 	return 0;
 }
 
-extern int __init_memblock __weak memblock_memory_can_coalesce(phys_addr_t addr1, phys_addr_t size1,
+int __init_memblock __weak memblock_memory_can_coalesce(phys_addr_t addr1, phys_addr_t size1,
 					  phys_addr_t addr2, phys_addr_t size2)
 {
 	return 1;
_

Patches currently in -mm which might be from jhbird.choi@samsung.com are

origin.patch
linux-next.patch

