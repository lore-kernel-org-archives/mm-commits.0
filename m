From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch removed
 from -mm tree
Date: Wed, 15 Nov 2017 16:58:12 -0800
Message-ID: <5a0ce2a4.A0V/5XAWCLhwtFwv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35732 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758750AbdKPA6N (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 19:58:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, tim.c.chen@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch

This patch was dropped because it was folded into mm-swap-fix-race-conditions-in-swap_slots-cache-init.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix

fix spello in comment

Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_slots.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swap_slots.c~mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix mm/swap_slots.c
--- a/mm/swap_slots.c~mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix
+++ a/mm/swap_slots.c
@@ -150,7 +150,7 @@ static int alloc_swap_slot_cache(unsigne
 	cache->cur = 0;
 	cache->n_ret = 0;
 	/*
-	 * We intialized alloc_lock and free_lock earlier.  We use
+	 * We initialized alloc_lock and free_lock earlier.  We use
 	 * !cache->slots or !cache->slots_ret to know if it is safe to acquire
 	 * the corresponding lock and use the cache.  Memory barrier below
 	 * ensures the assumption.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init.patch
f2fs-simplify-page-iteration-loops-fix.patch
mm-consolidate-page-table-accounting-fix-fix.patch
mm-stop-zeroing-memory-during-allocation-in-vmemmap-fix.patch
mm-batch-radix-tree-operations-when-truncating-pages-fix-fix.patch
mm-simplify-nodemask-printing-fix.patch
mm-make-alloc_node_mem_map-a-voidcall-if-we-dont-have-config_flat_node_mem_map-fix.patch

