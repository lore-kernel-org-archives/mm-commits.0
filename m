From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_allocc-eliminate-unsigned-confusion-in-__rmqueue_fallback-fix.patch removed from -mm tree
Date: Mon, 10 Jul 2017 15:33:58 -0700
Message-ID: <596400d6.f1Vd2VOCwTMAEv9E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41292 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754864AbdGJWd7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:33:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, haolee.swjtu@gmail.com, huang.ying.caritas@gmail.com, linux@rasmusvillemoes.dk, mhocko@suse.com, vbabka@suse.cz, weiyang@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_allocc-eliminate-unsigned-confusion-in-__rmqueue_fallback-fix
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-eliminate-unsigned-confusion-in-__rmqueue_fallback-fix.patch

This patch was dropped because it was folded into mm-page_allocc-eliminate-unsigned-confusion-in-__rmqueue_fallback.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_allocc-eliminate-unsigned-confusion-in-__rmqueue_fallback-fix

fix up reject fixupping

Cc: Hao Lee <haolee.swjtu@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <weiyang@gmail.com>
Cc: huang ying <huang.ying.caritas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_allocc-eliminate-unsigned-confusion-in-__rmqueue_fallback-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-eliminate-unsigned-confusion-in-__rmqueue_fallback-fix
+++ a/mm/page_alloc.c
@@ -2212,7 +2212,7 @@ static bool unreserve_highatomic_pageblo
  * condition simpler.
  */
 static inline bool
-__rmqueue_fallback(struct zone *zone, unsigned int order, int start_migratetype)
+__rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
 {
 	struct free_area *area;
 	int current_order;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_allocc-eliminate-unsigned-confusion-in-__rmqueue_fallback.patch
mm-zsmalloc-simplify-zs_max_alloc_size-handling-fix.patch
signal-avoid-undefined-behaviour-in-kill_something_info-fix.patch

