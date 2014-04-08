From: akpm@linux-foundation.org
Subject: [merged] mm-zswapc-remove-unnecessary-parentheses.patch removed
 from -mm tree
Date: Tue, 08 Apr 2014 14:14:08 -0700
Message-ID: <534466a0.y+4NOVH5ruTHR1Uk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56863 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757064AbaDHVOJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:14:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sjennings@variantweb.net, sj38.park@gmail.com

Subject: [merged] mm-zswapc-remove-unnecessary-parentheses.patch removed from -mm tree
To: sj38.park@gmail.com,sjennings@variantweb.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:14:08 -0700


The patch titled
     Subject: mm/zswap.c: remove unnecessary parentheses
has been removed from the -mm tree.  Its filename was
     mm-zswapc-remove-unnecessary-parentheses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj38.park@gmail.com>
Subject: mm/zswap.c: remove unnecessary parentheses

Fix following trivial checkpatch error:
	ERROR: return is not a function, parentheses are not required

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
Acked-by: Seth Jennings <sjennings@variantweb.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/zswap.c~mm-zswapc-remove-unnecessary-parentheses mm/zswap.c
--- a/mm/zswap.c~mm-zswapc-remove-unnecessary-parentheses
+++ a/mm/zswap.c
@@ -204,7 +204,7 @@ static struct kmem_cache *zswap_entry_ca
 static int zswap_entry_cache_create(void)
 {
 	zswap_entry_cache = KMEM_CACHE(zswap_entry, 0);
-	return (zswap_entry_cache == NULL);
+	return zswap_entry_cache == NULL;
 }
 
 static void zswap_entry_cache_destory(void)
@@ -408,8 +408,8 @@ cleanup:
 **********************************/
 static bool zswap_is_full(void)
 {
-	return (totalram_pages * zswap_max_pool_percent / 100 <
-		zswap_pool_pages);
+	return totalram_pages * zswap_max_pool_percent / 100 <
+		zswap_pool_pages;
 }
 
 /*********************************
_

Patches currently in -mm which might be from sj38.park@gmail.com are

origin.patch

