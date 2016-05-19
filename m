From: akpm@linux-foundation.org
Subject: [folded-merged]
 kernel-padata-hide-unused-functions-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 19 May 2016 16:36:46 -0700
Message-ID: <573e4e0e.+r532DvzkWahKSer%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44496 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbcESXgs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 19:36:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-padata-hide-unused-functions-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     kernel-padata-hide-unused-functions-checkpatch-fixes.patch

This patch was dropped because it was folded into kernel-padata-hide-unused-functions.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-padata-hide-unused-functions-checkpatch-fixes

ERROR: spaces required around that '=' (ctx:WxO)
#48: FILE: kernel/padata.c:689:
+		err =-EINVAL;
 		    ^

ERROR: space required before that '-' (ctx:OxV)
#48: FILE: kernel/padata.c:689:
+		err =-EINVAL;
 		     ^

total: 2 errors, 0 warnings, 86 lines checked

./patches/kernel-padata-hide-unused-functions.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/padata.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/padata.c~kernel-padata-hide-unused-functions-checkpatch-fixes kernel/padata.c
--- a/kernel/padata.c~kernel-padata-hide-unused-functions-checkpatch-fixes
+++ a/kernel/padata.c
@@ -659,7 +659,7 @@ int padata_start(struct padata_instance
 	mutex_lock(&pinst->lock);
 
 	if (pinst->flags & PADATA_INVALID)
-		err =-EINVAL;
+		err = -EINVAL;
 
 	 __padata_start(pinst);
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kernel-padata-hide-unused-functions.patch
mm-slab-freelist-randomization-v5-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
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

