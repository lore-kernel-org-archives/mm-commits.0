From: akpm@linux-foundation.org
Subject: [merged]
 mm-memblockc-fix-wrong-comment-in-__next_free_mem_range.patch removed from
 -mm tree
Date: Tue, 09 Jul 2013 16:20:23 -0700
Message-ID: <51dc9ab7.ZTx0xjdmhZeRfu38%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab3GIXUY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:20:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tangchen@cn.fujitsu.com

Subject: [merged] mm-memblockc-fix-wrong-comment-in-__next_free_mem_range.patch removed from -mm tree
To: tangchen@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:20:23 -0700


The patch titled
     Subject: mm/memblock.c: fix wrong comment in __next_free_mem_range()
has been removed from the -mm tree.  Its filename was
     mm-memblockc-fix-wrong-comment-in-__next_free_mem_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: mm/memblock.c: fix wrong comment in __next_free_mem_range()

Remove one redundant "nid" in the comment.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---

index c5fad93..a847bfe 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memblock.c~mm-memblockc-fix-wrong-comment-in-__next_free_mem_range mm/memblock.c
--- a/mm/memblock.c~mm-memblockc-fix-wrong-comment-in-__next_free_mem_range
+++ a/mm/memblock.c
@@ -566,7 +566,7 @@ int __init_memblock memblock_reserve(phy
 /**
  * __next_free_mem_range - next function for for_each_free_mem_range()
  * @idx: pointer to u64 loop variable
- * @nid: nid: node selector, %MAX_NUMNODES for all nodes
+ * @nid: node selector, %MAX_NUMNODES for all nodes
  * @out_start: ptr to phys_addr_t for start address of the range, can be %NULL
  * @out_end: ptr to phys_addr_t for end address of the range, can be %NULL
  * @out_nid: ptr to int for nid of the range, can be %NULL
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

origin.patch

