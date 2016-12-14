From: akpm@linux-foundation.org
Subject: [patch 092/114] radix-tree: fix typo
Date: Wed, 14 Dec 2016 15:08:31 -0800
Message-ID: <5851d0ef.PYuGUNMk/KeXx4Uz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35348 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933454AbcLNXId (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:08:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, willy@linux.intel.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mawilcox@microsoft.com, ross.zwisler@linux.intel.com

From: Matthew Wilcox <willy@linux.intel.com>
Subject: radix-tree: fix typo

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Tested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/radix-tree.c~radix-tree-fix-typo lib/radix-tree.c
--- a/lib/radix-tree.c~radix-tree-fix-typo
+++ a/lib/radix-tree.c
@@ -1110,7 +1110,7 @@ void **radix_tree_next_chunk(struct radi
 	 * because RADIX_TREE_MAP_SHIFT < BITS_PER_LONG.
 	 *
 	 * This condition also used by radix_tree_next_slot() to stop
-	 * contiguous iterating, and forbid swithing to the next chunk.
+	 * contiguous iterating, and forbid switching to the next chunk.
 	 */
 	index = iter->next_index;
 	if (!index && iter->index)
_
