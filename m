From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-relocate-comment-to-be-directly-above-code-it-refers-to.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:24:23 -0700
Message-ID: <51db11e7.S7LTJ1hEl8whj3wU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3GHTYY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:24:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, penberg@kernel.org, mgorman@suse.de, kosaki.motohiro@gmail.com, gilad@benyossef.com, cody@linux.vnet.ibm.com

Subject: [merged] mm-page_alloc-relocate-comment-to-be-directly-above-code-it-refers-to.patch removed from -mm tree
To: cody@linux.vnet.ibm.com,gilad@benyossef.com,kosaki.motohiro@gmail.com,mgorman@suse.de,penberg@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:24:23 -0700


The patch titled
     Subject: mm/page_alloc: relocate comment to be directly above code it refers to.
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-relocate-comment-to-be-directly-above-code-it-refers-to.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: mm/page_alloc: relocate comment to be directly above code it refers to.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-relocate-comment-to-be-directly-above-code-it-refers-to mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-relocate-comment-to-be-directly-above-code-it-refers-to
+++ a/mm/page_alloc.c
@@ -3711,12 +3711,12 @@ void __ref build_all_zonelists(pg_data_t
 		mminit_verify_zonelist();
 		cpuset_init_current_mems_allowed();
 	} else {
-		/* we have to stop all cpus to guarantee there is no user
-		   of zonelist */
 #ifdef CONFIG_MEMORY_HOTPLUG
 		if (zone)
 			setup_zone_pageset(zone);
 #endif
+		/* we have to stop all cpus to guarantee there is no user
+		   of zonelist */
 		stop_machine(__build_all_zonelists, pgdat, NULL);
 		/* cpuset refresh routine should be here */
 	}
_

Patches currently in -mm which might be from cody@linux.vnet.ibm.com are

origin.patch
zbud-add-to-mm.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch

