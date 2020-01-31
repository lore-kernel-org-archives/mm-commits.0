From: akpm@linux-foundation.org
Subject: [merged] mm-fix-comments-related-to-node-reclaim.patch
 removed from -mm tree
Date: Fri, 31 Jan 2020 15:19:35 -0800
Message-ID: <20200131231935.WA26UlZyT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgAaXTg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 18:19:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anshuman.khandual@arm.com, haolee.swjtu@gmail.com, mgorman@techsingularity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix comments related to node reclaim
has been removed from the -mm tree.  Its filename was
     mm-fix-comments-related-to-node-reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hao Lee <haolee.swjtu@gmail.com>
Subject: mm: fix comments related to node reclaim

As zone reclaim has been replaced by node reclaim, this patch fixes related
comments.

Link: http://lkml.kernel.org/r/20191126141346.GA22665@haolee.github.io
Signed-off-by: Hao Lee <haolee.swjtu@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h      |    2 +-
 include/uapi/linux/sysctl.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mmzone.h~mm-fix-comments-related-to-node-reclaim
+++ a/include/linux/mmzone.h
@@ -758,7 +758,7 @@ typedef struct pglist_data {
 
 #ifdef CONFIG_NUMA
 	/*
-	 * zone reclaim becomes active if more unmapped pages exist.
+	 * node reclaim becomes active if more unmapped pages exist.
 	 */
 	unsigned long		min_unmapped_pages;
 	unsigned long		min_slab_pages;
--- a/include/uapi/linux/sysctl.h~mm-fix-comments-related-to-node-reclaim
+++ a/include/uapi/linux/sysctl.h
@@ -195,7 +195,7 @@ enum
 	VM_MIN_UNMAPPED=32,	/* Set min percent of unmapped pages */
 	VM_PANIC_ON_OOM=33,	/* panic at out-of-memory */
 	VM_VDSO_ENABLED=34,	/* map VDSO into new processes? */
-	VM_MIN_SLAB=35,		 /* Percent pages ignored by zone reclaim */
+	VM_MIN_SLAB=35,		 /* Percent pages ignored by node reclaim */
 };
 
 
_

Patches currently in -mm which might be from haolee.swjtu@gmail.com are
