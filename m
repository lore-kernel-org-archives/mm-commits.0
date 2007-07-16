From: akpm@linux-foundation.org
Subject: - reiser4-export-radix_tree_preload.patch removed from -mm tree
Date: Mon, 16 Jul 2007 14:00:42 -0700
Message-ID: <200707162100.l6GL0gKM002653@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45714 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759758AbXGPVFO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:05:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: reiser@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: export radix_tree_preload() to modules
has been removed from the -mm tree.  Its filename was
     reiser4-export-radix_tree_preload.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: reiser4: export radix_tree_preload() to modules
From: Hans Reiser <reiser@namesys.com>


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/radix-tree.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN lib/radix-tree.c~reiser4-export-radix_tree_preload lib/radix-tree.c
--- a/lib/radix-tree.c~reiser4-export-radix_tree_preload
+++ a/lib/radix-tree.c
@@ -153,6 +153,7 @@ int radix_tree_preload(gfp_t gfp_mask)
 out:
 	return ret;
 }
+EXPORT_SYMBOL(radix_tree_preload);
 
 static inline void tag_set(struct radix_tree_node *node, unsigned int tag,
 		int offset)
_

Patches currently in -mm which might be from reiser@namesys.com are

reiser4-sb_sync_inodes.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
