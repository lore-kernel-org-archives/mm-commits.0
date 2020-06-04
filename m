From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-ksm-fix-a-typo-in-comment-alreaady-already-v2.patch removed from -mm
 tree
Date: Thu, 04 Jun 2020 16:20:02 -0700
Message-ID: <20200604232002.QeDBR_r6p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbgFDXUE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 19:20:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ethp@qq.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com


The patch titled
     Subject: mm: ksm: fix a typo in comment "alreaady"->"already"
has been removed from the -mm tree.  Its filename was
     mm-ksm-fix-a-typo-in-comment-alreaady-already-v2.patch

This patch was dropped because it was folded into mm-ksm-fix-a-typo-in-comment-alreaady-already.patch

------------------------------------------------------
From: Ethon Paul <ethp@qq.com>
Subject: mm: ksm: fix a typo in comment "alreaady"->"already"

There are some typos in comment, fix them.

s/wrprotected/write protected
s/undeflow/underflow

Link: http://lkml.kernel.org/r/20200411023644.15145-1-ethp@qq.com
Signed-off-by: Ethon Paul <ethp@qq.com>
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/ksm.c~mm-ksm-fix-a-typo-in-comment-alreaady-already-v2
+++ a/mm/ksm.c
@@ -612,7 +612,7 @@ static struct stable_node *alloc_stable_
 		 * Move the old stable node to the second dimension
 		 * queued in the hlist_dup. The invariant is that all
 		 * dup stable_nodes in the chain->hlist point to pages
-		 * that are wrprotected and have the exact same
+		 * that are write protected and have the exact same
 		 * content.
 		 */
 		stable_node_chain_add_dup(dup, chain);
@@ -1608,7 +1608,7 @@ again:
 			 * continue. All KSM pages belonging to the
 			 * stable_node dups in a stable_node chain
 			 * have the same content and they're
-			 * wrprotected at all times. Any will work
+			 * write protected at all times. Any will work
 			 * fine to continue the walk.
 			 */
 			tree_page = get_ksm_page(stable_node_any,
@@ -1843,7 +1843,7 @@ again:
 			 * continue. All KSM pages belonging to the
 			 * stable_node dups in a stable_node chain
 			 * have the same content and they're
-			 * wrprotected at all times. Any will work
+			 * write protected at all times. Any will work
 			 * fine to continue the walk.
 			 */
 			tree_page = get_ksm_page(stable_node_any,
@@ -2001,7 +2001,7 @@ static void stable_tree_append(struct rm
 	 * duplicate. page_migration could break later if rmap breaks,
 	 * so we can as well crash here. We really need to check for
 	 * rmap_hlist_len == STABLE_NODE_CHAIN, but we can as well check
-	 * for other negative values as an undeflow if detected here
+	 * for other negative values as an underflow if detected here
 	 * for the first time (and not when decreasing rmap_hlist_len)
 	 * would be sign of memory corruption in the stable_node.
 	 */
_

Patches currently in -mm which might be from ethp@qq.com are

mm-memory_hotplug-fix-a-typo-in-comment-recoreded-recorded.patch
mm-ksm-fix-a-typo-in-comment-alreaady-already.patch
mm-mmap-fix-a-typo-in-comment-compatbility-compatibility.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2.patch
mm-vmsan-fix-some-typos-in-comment.patch
mm-compaction-fix-a-typo-in-comment-pessemistic-pessimistic.patch
mm-memblock-fix-a-typo-in-comment-implict-implicit.patch
mm-list_lru-fix-a-typo-in-comment-numbesr-numbers.patch
mm-filemap-fix-a-typo-in-comment-unneccssary-unnecessary.patch
mm-frontswap-fix-some-typos-in-frontswapc.patch
mm-memcg-fix-some-typos-in-memcontrolc.patch
mm-fix-a-typo-in-comment-strucure-structure.patch
mm-slub-fix-a-typo-in-comment-disambiguiation-disambiguation.patch
mm-sparse-fix-a-typo-in-comment-convienence-convenience.patch
mm-page-writeback-fix-a-typo-in-comment-effictive-effective.patch
mm-memory-fix-a-typo-in-comment-attampt-attempt.patch
