From: akpm@linux-foundation.org
Subject: [folded-merged] add-lib-globc-fix.patch removed from -mm tree
Date: Wed, 06 Aug 2014 15:54:06 -0700
Message-ID: <53e2b20e.oBD+ALVwaX508aaP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f73.google.com ([209.85.192.73]:43844 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbaHFWyH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 18:54:07 -0400
Received: by mail-qg0-f73.google.com with SMTP id q107so439153qgd.2
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 15:54:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, linux@horizon.com, mm-commits@vger.kernel.org


The patch titled
     Subject: add-lib-globc-fix
has been removed from the -mm tree.  Its filename was
     add-lib-globc-fix.patch

This patch was dropped because it was folded into add-lib-globc.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: add-lib-globc-fix

fix sparse warning

Cc: George Spelvin <linux@horizon.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/glob.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/glob.c~add-lib-globc-fix lib/glob.c
--- a/lib/glob.c~add-lib-globc-fix
+++ a/lib/glob.c
@@ -45,7 +45,7 @@ bool __pure glob_match(char const *pat,
 	 * (no exception for /), it can be easily proved that there's
 	 * never a need to backtrack multiple levels.
 	 */
-	char const *back_pat = 0, *back_str = back_str;
+	char const *back_pat = NULL, *back_str = back_str;
 
 	/*
 	 * Loop over each token (character or class) in pat, matching
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
lib-list_sortc-convert-to-pr_foo-fix.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch

