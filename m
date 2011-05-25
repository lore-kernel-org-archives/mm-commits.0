From: akpm@linux-foundation.org
Subject: [merged] mm-remove-unused-zone_idx-variable-from-set_migratetype_isolate.patch removed from -mm tree
Date: Wed, 25 May 2011 13:27:17 -0700
Message-ID: <201105252025.p4PKPeCt014412@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34703 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932580Ab1EYUsz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:48:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, cl@linux.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: remove unused zone_idx variable from set_migratetype_isolate
has been removed from the -mm tree.  Its filename was
     mm-remove-unused-zone_idx-variable-from-set_migratetype_isolate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove unused zone_idx variable from set_migratetype_isolate
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/page_alloc.c~mm-remove-unused-zone_idx-variable-from-set_migratetype_isolate mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-unused-zone_idx-variable-from-set_migratetype_isolate
+++ a/mm/page_alloc.c
@@ -5502,10 +5502,8 @@ int set_migratetype_isolate(struct page 
 	struct memory_isolate_notify arg;
 	int notifier_ret;
 	int ret = -EBUSY;
-	int zone_idx;
 
 	zone = page_zone(page);
-	zone_idx = zone_idx(zone);
 
 	spin_lock_irqsave(&zone->lock, flags);
 
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch
linux-next.patch

