From: akpm@linux-foundation.org
Subject: [folded] mm-consolidate-init_mm-definition-fix.patch removed from -mm tree
Date: Tue, 16 Jun 2009 14:48:40 -0700
Message-ID: <200906162148.n5GLmfGD018530@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751321AbZFPVtK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 17:49:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@gmail.com, vapier.adi@gmail.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm-consolidate-init_mm-definition-fix
has been removed from the -mm tree.  Its filename was
     mm-consolidate-init_mm-definition-fix.patch

This patch was dropped because it was folded into mm-consolidate-init_mm-definition.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-consolidate-init_mm-definition-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Americo Wang <xiyou.wangcong@gmail.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/init-mm.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/init-mm.c~mm-consolidate-init_mm-definition-fix mm/init-mm.c
--- a/mm/init-mm.c~mm-consolidate-init_mm-definition-fix
+++ a/mm/init-mm.c
@@ -1,4 +1,11 @@
 #include <linux/mm_types.h>
+#include <linux/rbtree.h>
+#include <linux/rwsem.h>
+#include <linux/spinlock.h>
+#include <linux/list.h>
+#include <linux/cpumask.h>
+
+#include <asm/atomic.h>
 #include <asm/pgtable.h>
 
 struct mm_struct init_mm = {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
firmware_map-fix-hang-with-x86-32bit.patch
mm-consolidate-init_mm-definition.patch
mm-consolidate-init_mm-definition-fix.patch
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

