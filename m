From: akpm@linux-foundation.org
Subject: [folded-merged] mm-compaction-introduce-kcompactd-fix-4.patch
 removed from -mm tree
Date: Thu, 17 Mar 2016 13:51:17 -0700
Message-ID: <56eb18c5.CvCD5uTn2XG2z0Zb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030342AbcCQUvX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 16:51:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-introduce-kcompactd-fix-4
has been removed from the -mm tree.  Its filename was
     mm-compaction-introduce-kcompactd-fix-4.patch

This patch was dropped because it was folded into mm-compaction-introduce-kcompactd.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-compaction-introduce-kcompactd-fix-4

Fix typo in /proc/vmstat for kcompactd wakeups. Per Hugh's suggestion,
rename the item to compact_daemon_wake.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmstat.c~mm-compaction-introduce-kcompactd-fix-4 mm/vmstat.c
--- a/mm/vmstat.c~mm-compaction-introduce-kcompactd-fix-4
+++ a/mm/vmstat.c
@@ -826,7 +826,7 @@ const char * const vmstat_text[] = {
 	"compact_stall",
 	"compact_fail",
 	"compact_success",
-	"compact_kcompatd_wake",
+	"compact_daemon_wake",
 #endif
 
 #ifdef CONFIG_HUGETLB_PAGE
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-kswapd-remove-bogus-check-of-balance_classzone_idx.patch
mm-compaction-introduce-kcompactd.patch
mm-memory-hotplug-small-cleanup-in-online_pages.patch
mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd.patch
mm-tracing-refresh-__def_vmaflag_names-fix.patch
mm-use-radix_tree_iter_retry-fix.patch

