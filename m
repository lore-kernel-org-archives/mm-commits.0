From: akpm@linux-foundation.org
Subject: + prio_tree-remove-unnecessary-code-in-prio_tree_replace.patch added to -mm tree
Date: Tue, 14 Feb 2012 16:19:15 -0800
Message-ID: <20120215001916.12C4FA0245@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:37706 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757445Ab2BOATS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2012 19:19:18 -0500
Received: by eaaf13 with SMTP id f13so14726eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Feb 2012 16:19:17 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaoguangrong@linux.vnet.ibm.com


The patch titled
     Subject: prio_tree: remove unnecessary code in prio_tree_replace
has been added to the -mm tree.  Its filename is
     prio_tree-remove-unnecessary-code-in-prio_tree_replace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: prio_tree: remove unnecessary code in prio_tree_replace

Remove the code since 'node' has already been initialized in the begin of
the function

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/prio_tree.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN lib/prio_tree.c~prio_tree-remove-unnecessary-code-in-prio_tree_replace lib/prio_tree.c
--- a/lib/prio_tree.c~prio_tree-remove-unnecessary-code-in-prio_tree_replace
+++ a/lib/prio_tree.c
@@ -151,7 +151,6 @@ struct prio_tree_node *prio_tree_replace
 		 * We can reduce root->index_bits here. However, it is complex
 		 * and does not help much to improve performance (IMO).
 		 */
-		node->parent = node;
 		root->prio_tree_node = node;
 	} else {
 		node->parent = old->parent;
_
Subject: Subject: prio_tree: remove unnecessary code in prio_tree_replace

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

hugetlbfs-fix-hugetlb_get_unmapped_area.patch
hugetlb-drop-prev_vma-in-hugetlb_get_unmapped_area_topdown.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-do-not-reset-cached_hole_size-when-vma-is-unmapped.patch
mm-search-from-free_area_cache-for-the-bigger-size.patch
prio_tree-remove-unnecessary-code-in-prio_tree_replace.patch
prio_tree-cleanup-prio_tree_left-prio_tree_right.patch
prio_tree-simplify-prio_tree_expand.patch
prio_tree-introduce-prio_set_parent.patch

