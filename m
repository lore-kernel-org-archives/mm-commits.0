From: akpm@linux-foundation.org
Subject: [folded] rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 16 Jun 2009 15:07:05 -0700
Message-ID: <200906162207.n5GM75AY003276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753623AbZFPWHN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 18:07:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, wstrepp@gmx.de, mm-commits@vger.kernel.org


The patch titled
     rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch

This patch was dropped because it was folded into rb_tree-reorganize-code-in-rb_erase-for-additional-changes.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: that open brace { should be on the previous line
#21: FILE: lib/rbtree.c:235:
+		if (rb_parent(old))
+		{

total: 1 errors, 0 warnings, 31 lines checked

./patches/rb_tree-reorganize-code-in-rb_erase-for-additional-changes.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Wolfram Strepp" <wstrepp@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Wolfram Strepp <wstrepp@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rbtree.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN lib/rbtree.c~rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes lib/rbtree.c
--- a/lib/rbtree.c~rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes
+++ a/lib/rbtree.c
@@ -232,8 +232,7 @@ void rb_erase(struct rb_node *node, stru
 		while ((left = node->rb_left) != NULL)
 			node = left;
 
-		if (rb_parent(old))
-		{
+		if (rb_parent(old)) {
 			if (rb_parent(old)->rb_left == old)
 				rb_parent(old)->rb_left = node;
 			else
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
vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb-fix.patch
fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers-checkpatch-fixes.patch
fbdev-s1d13xxxfb-add-accelerated-bitblt-functions-checkpatch-fixes.patch

