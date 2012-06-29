From: akpm@linux-foundation.org
Subject: [merged] mm-cleanup-on-the-comments-of-zone_reclaim_stat.patch removed from -mm tree
Date: Fri, 29 Jun 2012 13:18:11 -0700
Message-ID: <20120629201811.AD3C9A0244@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:41741 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab2F2USN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jun 2012 16:18:13 -0400
Received: by vcbfl13 with SMTP id fl13so411629vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 29 Jun 2012 13:18:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: liwp@linux.vnet.ibm.com, liwp.linux@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix zone_reclaim_stat() comment
has been removed from the -mm tree.  Its filename was
     mm-cleanup-on-the-comments-of-zone_reclaim_stat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Wanpeng Li <liwp@linux.vnet.ibm.com>
Subject: mm: fix zone_reclaim_stat() comment

Signed-off-by: Wanpeng Li <liwp.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mmzone.h~mm-cleanup-on-the-comments-of-zone_reclaim_stat include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-cleanup-on-the-comments-of-zone_reclaim_stat
+++ a/include/linux/mmzone.h
@@ -187,7 +187,7 @@ static inline int is_unevictable_lru(enu
 struct zone_reclaim_stat {
 	/*
 	 * The pageout code in vmscan.c keeps track of how many of the
-	 * mem/swap backed and file backed pages are refeferenced.
+	 * mem/swap backed and file backed pages are referenced.
 	 * The higher the rotated/scanned ratio, the more valuable
 	 * that cache is.
 	 *
_

Patches currently in -mm which might be from liwp@linux.vnet.ibm.com are

origin.patch
linux-next.patch
mm-prepare-for-removal-of-obsolete-proc-sys-vm-nr_pdflush_threads.patch
mm-remove-unused-lru_all_evictable.patch
memcg-rename-mem_control_xxx-to-memcg_xxx.patch

