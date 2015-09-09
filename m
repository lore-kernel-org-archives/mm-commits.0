From: akpm@linux-foundation.org
Subject: [merged] mm-memblockc-fix-comment-in-the-__next_mem_range.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 12:53:51 -0700
Message-ID: <55f08e4f.vKdSNoU9PVerOJfC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41341 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbbIITxw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:53:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: fix comment in __next_mem_range()
has been removed from the -mm tree.  Its filename was
     mm-memblockc-fix-comment-in-the-__next_mem_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: mm/memblock.c: fix comment in __next_mem_range()

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memblock.c~mm-memblockc-fix-comment-in-the-__next_mem_range mm/memblock.c
--- a/mm/memblock.c~mm-memblockc-fix-comment-in-the-__next_mem_range
+++ a/mm/memblock.c
@@ -976,7 +976,7 @@ void __init_memblock __next_mem_range(u6
  * in type_b.
  *
  * @idx: pointer to u64 loop variable
- * @nid: nid: node selector, %NUMA_NO_NODE for all nodes
+ * @nid: node selector, %NUMA_NO_NODE for all nodes
  * @flags: pick from blocks based on memory attributes
  * @type_a: pointer to memblock_type from where the range is taken
  * @type_b: pointer to memblock_type which excludes memory from being taken
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are


