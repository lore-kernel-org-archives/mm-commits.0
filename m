From: akpm@linux-foundation.org
Subject: [merged] mm-remove-struct-node_active_region.patch removed from
 -mm tree
Date: Tue, 08 Sep 2015 11:12:09 -0700
Message-ID: <55ef24f9.y5rP//lnLg3p38Q0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbbIHSMJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:12:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minkyung88.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove struct node_active_region
has been removed from the -mm tree.  Its filename was
     mm-remove-struct-node_active_region.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "minkyung88.kim" <minkyung88.kim@lge.com>
Subject: mm: remove struct node_active_region

struct node_active_region is not used anymore.  Remove it.

Signed-off-by: minkyung88.kim <minkyung88.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    8 --------
 1 file changed, 8 deletions(-)

diff -puN include/linux/mmzone.h~mm-remove-struct-node_active_region include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-remove-struct-node_active_region
+++ a/include/linux/mmzone.h
@@ -690,14 +690,6 @@ struct zonelist {
 #endif
 };
 
-#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
-struct node_active_region {
-	unsigned long start_pfn;
-	unsigned long end_pfn;
-	int nid;
-};
-#endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
