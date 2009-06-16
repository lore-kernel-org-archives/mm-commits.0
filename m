From: akpm@linux-foundation.org
Subject: [folded] mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports-fix.patch removed from -mm tree
Date: Tue, 16 Jun 2009 15:00:38 -0700
Message-ID: <200906162200.n5GM0ccL029785@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751078AbZFPWBP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 18:01:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hch@infradead.org, mel@csn.ul.ie, minchan.kim@gmail.com, penberg@cs.helsinki.fi, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports-fix
has been removed from the -mm tree.  Its filename was
     mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports-fix.patch

This patch was dropped because it was folded into mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gfp-translate |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/gfp-translate~mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports-fix scripts/gfp-translate
--- a/scripts/gfp-translate~mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports-fix
+++ a/scripts/gfp-translate
@@ -53,7 +53,7 @@ fi
 
 # Confirm that a source directory exists
 if [ ! -r "$SOURCE/Makefile" ]; then
-	die "Could not locate source directory or it is invalid"
+	die "Could not locate kernel source directory or it is invalid"
 fi
 
 # Confirm that a GFP mask has been specified
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
mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports.patch
mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports-fix.patch
vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails-fix.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched-fix.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb-fix.patch
fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers-checkpatch-fixes.patch
fbdev-s1d13xxxfb-add-accelerated-bitblt-functions-checkpatch-fixes.patch

