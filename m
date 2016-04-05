From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 05 Apr 2016 14:19:10 -0700
Message-ID: <57042bce.qQlDkTJoIdO1lTh4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52586 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760140AbcDEVTL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 17:19:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes

ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit 0123456789ab ("commit description")'
#9: 
The first condition was added by a41f24ea9fd6 ("page allocator: smarter

WARNING: line over 80 characters
#47: FILE: mm/page_alloc.c:3005:
+ * the last reclaim round) and no_progress_loops (number of reclaim rounds without

total: 1 errors, 1 warnings, 68 lines checked

./patches/mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes mm/page_alloc.c
--- a/mm/page_alloc.c~mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes
+++ a/mm/page_alloc.c
@@ -3150,9 +3150,9 @@ static inline bool is_thp_gfp_mask(gfp_t
  * Checks whether it makes sense to retry the reclaim to make a forward progress
  * for the given allocation request.
  * The reclaim feedback represented by did_some_progress (any progress during
- * the last reclaim round) and no_progress_loops (number of reclaim rounds without
- * any progress in a row) is considered as well as the reclaimable pages on the
- * applicable zone list (with a backoff mechanism which is a function of
+ * the last reclaim round) and no_progress_loops (number of reclaim rounds
+ * without any progress in a row) is considered as well as the reclaimable pages
+ * on the applicable zone list (with a backoff mechanism which is a function of
  * no_progress_loops).
  *
  * Returns true if a retry is viable or false to enter the oom path.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-compaction-direct-freepage-allocation-for-async-direct-compaction-checkpatch-fixes.patch
mm-uninline-page_mapped.patch
mm-uninline-page_mapped-checkpatch-fixes.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

