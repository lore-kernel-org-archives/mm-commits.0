From: akpm@linux-foundation.org
Subject: + mm-memblockc-fix-comment-in-the-__next_mem_range.patch added to -mm tree
Date: Mon, 31 Aug 2015 15:59:08 -0700
Message-ID: <55e4dc3c.7nAQBpR7erKSO0SE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbbHaW7I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Aug 2015 18:59:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock.c: fix comment in __next_mem_range()
has been added to the -mm tree.  Its filename is
     mm-memblockc-fix-comment-in-the-__next_mem_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblockc-fix-comment-in-the-__next_mem_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblockc-fix-comment-in-the-__next_mem_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

sh-use-pfn_down-macro.patch
mm-memblock-rename-local-variable-of-memblock_type-to-type.patch
mm-memblock-typo-fixed.patch
mm-memblockc-fix-comment-in-the-__next_mem_range.patch

