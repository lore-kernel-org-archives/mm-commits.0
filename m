From: akpm@linux-foundation.org
Subject: [folded-merged] lib-list_sortc-convert-to-pr_foo-fix.patch
 removed from -mm tree
Date: Wed, 06 Aug 2014 15:54:35 -0700
Message-ID: <53e2b22b.Q+7tRw80URhFc7xK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:63132 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbaHFWyg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 18:54:36 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so843400pdj.0
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 15:54:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, artem.bityutskiy@linux.intel.com, david@fromorbit.com, don.mullis@gmail.com, linux@rasmusvillemoes.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-list_sortc-convert-to-pr_foo-fix
has been removed from the -mm tree.  Its filename was
     lib-list_sortc-convert-to-pr_foo-fix.patch

This patch was dropped because it was folded into lib-list_sortc-convert-to-pr_foo.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-list_sortc-convert-to-pr_foo-fix

Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Don Mullis <don.mullis@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_sort.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN lib/list_sort.c~lib-list_sortc-convert-to-pr_foo-fix lib/list_sort.c
--- a/lib/list_sort.c~lib-list_sortc-convert-to-pr_foo-fix
+++ a/lib/list_sort.c
@@ -128,8 +128,7 @@ void list_sort(void *priv, struct list_h
 		}
 		if (lev > max_lev) {
 			if (unlikely(lev >= ARRAY_SIZE(part)-1)) {
-				pr_debug_once("list passed to list_sort() too "
-					      "long for efficiency\n");
+				printk_once(KERN_DEBUG "list too long for efficiency\n");
 				lev--;
 			}
 			max_lev = lev;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fsnotify-rename-event-handling-functions.patch
kbuild-explain-stack-protector-strong-config-logic.patch
slub-use-new-node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu.patch
add-lib-globc.patch
lib-list_sortc-convert-to-pr_foo.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch

