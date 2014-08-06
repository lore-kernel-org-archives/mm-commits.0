From: akpm@linux-foundation.org
Subject: [folded-merged]
 slub-use-new-node-functions-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 06 Aug 2014 15:42:34 -0700
Message-ID: <53e2af5a.kvG5wlvIt3N1163h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:50799 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753927AbaHFWmf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 18:42:35 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so608694obb.4
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 15:42:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub-use-new-node-functions-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     slub-use-new-node-functions-checkpatch-fixes.patch

This patch was dropped because it was folded into slub-use-new-node-functions.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: slub-use-new-node-functions-checkpatch-fixes

ERROR: space required before the open parenthesis '('
#189: FILE: mm/slub.c:4350:
+	for(node = 0; node < nr_node_ids; node++)

total: 1 errors, 0 warnings, 192 lines checked

./patches/slub-use-new-node-functions.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~slub-use-new-node-functions-checkpatch-fixes mm/slub.c
--- a/mm/slub.c~slub-use-new-node-functions-checkpatch-fixes
+++ a/mm/slub.c
@@ -4347,7 +4347,7 @@ static ssize_t show_slab_objects(struct
 	}
 	x = sprintf(buf, "%lu", total);
 #ifdef CONFIG_NUMA
-	for(node = 0; node < nr_node_ids; node++)
+	for (node = 0; node < nr_node_ids; node++)
 		if (nodes[node])
 			x += sprintf(buf + x, " N%d=%lu",
 					node, nodes[node]);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fsnotify-rename-event-handling-functions.patch
kbuild-explain-stack-protector-strong-config-logic.patch
slub-use-new-node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch

