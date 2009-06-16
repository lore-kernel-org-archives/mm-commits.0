From: akpm@linux-foundation.org
Subject: [folded] page-allocator-add-inactive-ratio-calculation-function-of-each-zone-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 16 Jun 2009 14:59:34 -0700
Message-ID: <200906162159.n5GLxYeU028770@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752904AbZFPV7d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 17:59:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     page-allocator-add-inactive-ratio-calculation-function-of-each-zone-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     page-allocator-add-inactive-ratio-calculation-function-of-each-zone-checkpatch-fixes.patch

This patch was dropped because it was folded into page-allocator-add-inactive-ratio-calculation-function-of-each-zone.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-allocator-add-inactive-ratio-calculation-function-of-each-zone-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: trailing whitespace
#134: FILE: mm/page_alloc.c:4575:
+^I^Icalculate_zone_inactive_ratio(zone);^I$

total: 1 errors, 0 warnings, 45 lines checked

./patches/page-allocator-add-inactive-ratio-calculation-function-of-each-zone.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~page-allocator-add-inactive-ratio-calculation-function-of-each-zone-checkpatch-fixes mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-add-inactive-ratio-calculation-function-of-each-zone-checkpatch-fixes
+++ a/mm/page_alloc.c
@@ -4584,7 +4584,7 @@ static void __init setup_per_zone_inacti
 	struct zone *zone;
 
 	for_each_zone(zone)
-		calculate_zone_inactive_ratio(zone);	
+		calculate_zone_inactive_ratio(zone);
 }
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
firmware_map-fix-hang-with-x86-32bit.patch
mm-consolidate-init_mm-definition.patch
readahead-record-mmap-read-around-states-in-file_ra_state.patch
mm-clean-up-get_user_pages_fast-documentation.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
pagemap-add-page-types-tool.patch
videobuf-dma-contig-zero-copy-userptr-support-v3.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
page-allocator-clean-up-functions-related-to-pages_min.patch
page-allocator-add-inactive-ratio-calculation-function-of-each-zone.patch
page-allocator-add-inactive-ratio-calculation-function-of-each-zone-checkpatch-fixes.patch
mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports-fix.patch
vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails-fix.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched-fix.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb-fix.patch
fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers-checkpatch-fixes.patch
fbdev-s1d13xxxfb-add-accelerated-bitblt-functions-checkpatch-fixes.patch

