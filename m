From: akpm@linux-foundation.org
Subject: [folded] readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 16 Jun 2009 14:49:22 -0700
Message-ID: <200906162149.n5GLnMxv019172@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751646AbZFPVtx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 17:49:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, wfg@mail.ustc.edu.cn, mm-commits@vger.kernel.org


The patch titled
     readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch

This patch was dropped because it was folded into readahead-record-mmap-read-around-states-in-file_ra_state.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#42: FILE: include/linux/mm.h:1202:
+^I^I        struct address_space *mapping,$

total: 1 errors, 0 warnings, 83 lines checked

./patches/readahead-record-mmap-read-around-states-in-file_ra_state.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mm.h~readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes include/linux/mm.h
--- a/include/linux/mm.h~readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes
+++ a/include/linux/mm.h
@@ -1196,7 +1196,7 @@ void page_cache_async_readahead(struct a
 
 unsigned long max_sane_readahead(unsigned long nr);
 unsigned long ra_submit(struct file_ra_state *ra,
-		        struct address_space *mapping,
+			struct address_space *mapping,
 			struct file *filp);
 
 /* Do stack extension */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
firmware_map-fix-hang-with-x86-32bit.patch
mm-consolidate-init_mm-definition.patch
readahead-record-mmap-read-around-states-in-file_ra_state.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
pagemap-add-page-types-tool-fix.patch
videobuf-dma-contig-zero-copy-userptr-support-v3-comments-checkpatch-fixes.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
page-allocator-clean-up-functions-related-to-pages_min-checkpatch-fixes.patch
page-allocator-add-inactive-ratio-calculation-function-of-each-zone-checkpatch-fixes.patch
mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports-fix.patch
vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails-fix.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched-fix.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb-fix.patch
fbdev-add-support-for-handoff-from-firmware-to-hw-framebuffers-checkpatch-fixes.patch
fbdev-s1d13xxxfb-add-accelerated-bitblt-functions-checkpatch-fixes.patch

