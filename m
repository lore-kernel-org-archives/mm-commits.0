From: akpm@linux-foundation.org
Subject: [merged] mm-remove-unused-lru_all_evictable.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:13:58 -0700
Message-ID: <20120801201359.165D6200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:51698 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2HAUOA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:14:00 -0400
Received: by mail-ey0-f202.google.com with SMTP id o12so293205eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:14:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liwp@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, liwp.linux@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove unused LRU_ALL_EVICTABLE
has been removed from the -mm tree.  Its filename was
     mm-remove-unused-lru_all_evictable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: mm: remove unused LRU_ALL_EVICTABLE

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/mmzone.h~mm-remove-unused-lru_all_evictable include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-remove-unused-lru_all_evictable
+++ a/include/linux/mmzone.h
@@ -209,7 +209,6 @@ struct lruvec {
 /* Mask used at gathering information at once (see memcontrol.c) */
 #define LRU_ALL_FILE (BIT(LRU_INACTIVE_FILE) | BIT(LRU_ACTIVE_FILE))
 #define LRU_ALL_ANON (BIT(LRU_INACTIVE_ANON) | BIT(LRU_ACTIVE_ANON))
-#define LRU_ALL_EVICTABLE (LRU_ALL_FILE | LRU_ALL_ANON)
 #define LRU_ALL	     ((1 << NR_LRU_LISTS) - 1)
 
 /* Isolate clean file */
_

Patches currently in -mm which might be from liwp@linux.vnet.ibm.com are

origin.patch
linux-next.patch

