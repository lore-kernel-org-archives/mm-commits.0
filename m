From: akpm@linux-foundation.org
Subject: [folded] videobuf-dma-contig-zero-copy-userptr-support-v3-comments-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 16 Jun 2009 14:58:20 -0700
Message-ID: <200906162158.n5GLwKp3027517@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752205AbZFPV7F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 17:59:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, damm@igel.co.jp, hannes@cmpxchg.org, hverkuil@xs4all.nl, lethal@linux-sh.org, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     videobuf-dma-contig-zero-copy-userptr-support-v3-comments-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     videobuf-dma-contig-zero-copy-userptr-support-v3-comments-checkpatch-fixes.patch

This patch was dropped because it was folded into videobuf-dma-contig-zero-copy-userptr-support-v3.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: videobuf-dma-contig-zero-copy-userptr-support-v3-comments-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: trailing whitespace
#28: FILE: drivers/media/video/videobuf-dma-contig.c:117:
+ * This function resets the user space pointer $

total: 1 errors, 0 warnings, 28 lines checked

./patches/videobuf-dma-contig-zero-copy-userptr-support-v3-comments.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Magnus Damm <damm@igel.co.jp>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/videobuf-dma-contig.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/videobuf-dma-contig.c~videobuf-dma-contig-zero-copy-userptr-support-v3-comments-checkpatch-fixes drivers/media/video/videobuf-dma-contig.c
--- a/drivers/media/video/videobuf-dma-contig.c~videobuf-dma-contig-zero-copy-userptr-support-v3-comments-checkpatch-fixes
+++ a/drivers/media/video/videobuf-dma-contig.c
@@ -114,7 +114,7 @@ static struct vm_operations_struct video
  * videobuf_dma_contig_user_put() - reset pointer to user space buffer
  * @mem: per-buffer private videobuf-dma-contig data
  *
- * This function resets the user space pointer 
+ * This function resets the user space pointer
  */
 static void videobuf_dma_contig_user_put(struct videobuf_dma_contig_memory *mem)
 {
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

