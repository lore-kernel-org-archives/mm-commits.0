From: akpm@linux-foundation.org
Subject: [folded] mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 16 Jun 2009 14:50:10 -0700
Message-ID: <200906162150.n5GLoB8B019979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752142AbZFPVur (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 17:50:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andy.grover@oracle.com, nickpiggin@yahoo.com.au, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-clean-up-get_user_pages_fast-documentation.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: space required after that ',' (ctx:VxV)
#29: FILE: include/linux/mm.h:829:
+			unsigned long start, int len,int write, int force,
 			                            ^

total: 1 errors, 0 warnings, 113 lines checked

./patches/mm-clean-up-get_user_pages_fast-documentation.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andy Grover <andy.grover@oracle.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mm.h~mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes include/linux/mm.h
--- a/include/linux/mm.h~mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes
+++ a/include/linux/mm.h
@@ -825,7 +825,7 @@ extern int make_pages_present(unsigned l
 extern int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, int len, int write);
 
 int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
-			unsigned long start, int len,int write, int force,
+			unsigned long start, int len, int write, int force,
 			struct page **pages, struct vm_area_struct **vmas);
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
firmware_map-fix-hang-with-x86-32bit.patch
mm-consolidate-init_mm-definition.patch
readahead-record-mmap-read-around-states-in-file_ra_state.patch
mm-clean-up-get_user_pages_fast-documentation.patch
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

