From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch removed from -mm tree
Date: Tue, 14 Apr 2015 15:15:31 -0700
Message-ID: <552d9183.KRX+6AfePqrWDS87%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54307 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbbDNWPc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Apr 2015 18:15:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, khlebnikov@yandex-team.ru, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hide-per-cpu-lists-in-output-of-show_mem-fix
has been removed from the -mm tree.  Its filename was
     mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch

This patch was dropped because it was folded into mm-hide-per-cpu-lists-in-output-of-show_mem.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hide-per-cpu-lists-in-output-of-show_mem-fix

update show_free_areas comment

Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-hide-per-cpu-lists-in-output-of-show_mem-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-hide-per-cpu-lists-in-output-of-show_mem-fix
+++ a/mm/page_alloc.c
@@ -3251,8 +3251,11 @@ static void show_migration_types(unsigne
  * Show free area list (used inside shift_scroll-lock stuff)
  * We also calculate the percentage fragmentation. We do this by counting the
  * memory on each free list with the exception of the first item on the list.
- * Suppresses nodes that are not allowed by current's cpuset if
- * SHOW_MEM_FILTER_NODES is passed.
+ *
+ * Bits in @filter:
+ * SHOW_MEM_FILTER_NODES: suppress nodes that are not allowed by current's
+ *   cpuset.
+ * SHOW_MEM_PERCPU_LISTS: display full per-node per-cpu pcp lists
  */
 void show_free_areas(unsigned int filter)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ocfs2-make-mlog_errno-return-the-errno.patch
mm-migrate-mark-unmap_and_move-noinline-to-avoid-ice-in-gcc-473.patch
mm-cma-release-trigger.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition.patch
page_writeback-cleanup-mess-around-cancel_dirty_page.patch
mm-hide-per-cpu-lists-in-output-of-show_mem.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings-fix.patch
mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes.patch

