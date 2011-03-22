From: akpm@linux-foundation.org
Subject: [folded] mm-batch-free-pcp-list-if-possible-fix.patch removed from -mm tree
Date: Tue, 22 Mar 2011 15:58:45 -0700
Message-ID: <201103222258.p2MMwjmd032689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754393Ab1CVW7s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Mar 2011 18:59:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mel@csn.ul.ie, namhyung@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm-batch-free-pcp-list-if-possible-fix
has been removed from the -mm tree.  Its filename was
     mm-batch-free-pcp-list-if-possible-fix.patch

This patch was dropped because it was folded into mm-batch-free-pcp-list-if-possible.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-batch-free-pcp-list-if-possible-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix comment

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-batch-free-pcp-list-if-possible-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-batch-free-pcp-list-if-possible-fix
+++ a/mm/page_alloc.c
@@ -614,7 +614,7 @@ static void free_pcppages_bulk(struct zo
 			list = &pcp->lists[migratetype];
 		} while (list_empty(list));
 
-		/* This is an only non-empty list. Free them all. */
+		/* This is the only non-empty list. Free them all. */
 		if (batch_free == MIGRATE_PCPTYPES)
 			batch_free = to_free;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-asm-generic-unistdh-fix-syncfs-syscall-number.patch
leds-convert-bd2802-driver-to-dev_pm_ops.patch
mm-vmap-area-cache.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page.patch
mm-batch-free-pcp-list-if-possible.patch
memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list-fix.patch
pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration-fix.patch
mm-add-__gfp_other_node-flag-checkpatch-fixes.patch
mm-use-__gfp_other_node-for-transparent-huge-pages-checkpatch-fixes.patch
drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv-fix.patch
kernel-cpuc-fix-many-errors-related-to-style-fix.patch
calibrate-retry-with-wider-bounds-when-converge-seems-to-fail-fix.patch
kernel-watchdogc-allow-hardlockup-to-panic-by-default-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
fs-coda-fix-compile-warning-when-config_sysctl=n-fix.patch
documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix.patch
documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix-fix.patch

