From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-drop-migrate-type-checks-from-has_unmovable_pages-fix.patch removed from -mm tree
Date: Wed, 15 Nov 2017 16:56:40 -0800
Message-ID: <5a0ce248.p6og1fSWBYJ3Q+jS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35356 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758010AbdKPA4l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 19:56:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-drop-migrate-type-checks-from-has_unmovable_pages-fix
has been removed from the -mm tree.  Its filename was
     mm-drop-migrate-type-checks-from-has_unmovable_pages-fix.patch

This patch was dropped because it was folded into mm-drop-migrate-type-checks-from-has_unmovable_pages.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-drop-migrate-type-checks-from-has_unmovable_pages-fix

remove unused local `mt'

Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/page_alloc.c~mm-drop-migrate-type-checks-from-has_unmovable_pages-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-drop-migrate-type-checks-from-has_unmovable_pages-fix
+++ a/mm/page_alloc.c
@@ -7352,7 +7352,6 @@ bool has_unmovable_pages(struct zone *zo
 			 bool skip_hwpoisoned_pages)
 {
 	unsigned long pfn, iter, found;
-	int mt;
 
 	/*
 	 * For avoiding noise data, lru_add_drain_all() should be called
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-drop-migrate-type-checks-from-has_unmovable_pages.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
f2fs-simplify-page-iteration-loops-fix.patch
mm-consolidate-page-table-accounting-fix-fix.patch
mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix.patch
mm-batch-radix-tree-operations-when-truncating-pages-fix-fix.patch
mm-simplify-nodemask-printing-fix.patch
mm-make-alloc_node_mem_map-a-voidcall-if-we-dont-have-config_flat_node_mem_map-fix.patch

