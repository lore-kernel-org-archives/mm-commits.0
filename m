From: akpm@linux-foundation.org
Subject: [folded-merged]
 include-linux-apply-__malloc-attribute-checkpatch-fixes.patch removed from
 -mm tree
Date: Thu, 19 May 2016 16:44:15 -0700
Message-ID: <573e4fcf.RFp2VqDwy/OBtBll%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44872 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbcESXoQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 19:44:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: include-linux-apply-__malloc-attribute-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     include-linux-apply-__malloc-attribute-checkpatch-fixes.patch

This patch was dropped because it was folded into include-linux-apply-__malloc-attribute.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include-linux-apply-__malloc-attribute-checkpatch-fixes

ERROR: "foo * bar" should be "foo *bar"
#171: FILE: include/linux/mempool.h:35:
+extern void * mempool_alloc(mempool_t *pool, gfp_t gfp_mask) __malloc;

Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempool.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mempool.h~include-linux-apply-__malloc-attribute-checkpatch-fixes include/linux/mempool.h
--- a/include/linux/mempool.h~include-linux-apply-__malloc-attribute-checkpatch-fixes
+++ a/include/linux/mempool.h
@@ -32,7 +32,7 @@ extern mempool_t *mempool_create_node(in
 
 extern int mempool_resize(mempool_t *pool, int new_min_nr);
 extern void mempool_destroy(mempool_t *pool);
-extern void * mempool_alloc(mempool_t *pool, gfp_t gfp_mask) __malloc;
+extern void *mempool_alloc(mempool_t *pool, gfp_t gfp_mask) __malloc;
 extern void mempool_free(void *element, mempool_t *pool);
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-apply-__malloc-attribute.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-uninline-page_mapped.patch
mm-uninline-page_mapped-checkpatch-fixes.patch
memory_hotplug-introduce-config_memory_hotplug_default_online-fix.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path-fix.patch
mm-page_alloc-only-check-pagecompound-for-high-order-pages-fix.patch
mm-page_alloc-remove-unnecessary-initialisation-from-__alloc_pages_nodemask-fix.patch
mm-page_alloc-shorten-the-page-allocator-fast-path-fix.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice-fix.patch
mm-page_alloc-un-inline-the-bad-part-of-free_pages_check-fix.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix.patch
mm-page_alloc-dont-duplicate-code-in-free_pcp_prepare-fix-fix.patch

