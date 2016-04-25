From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-compaction-direct-freepage-allocation-for-async-direct-compaction-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 25 Apr 2016 12:58:37 -0700
Message-ID: <571e76ed.7PLey5kEaLUDIcq3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919AbcDYT6i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Apr 2016 15:58:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-direct-freepage-allocation-for-async-direct-compaction-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-compaction-direct-freepage-allocation-for-async-direct-compaction-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-compaction-direct-freepage-allocation-for-async-direct-compaction.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-compaction-direct-freepage-allocation-for-async-direct-compaction-checkpatch-fixes

ERROR: "foo * bar" should be "foo *bar"
#168: FILE: mm/internal.h:148:
+extern struct page * alloc_pages_zone(struct zone *zone, unsigned int order,

total: 1 errors, 0 warnings, 159 lines checked

./patches/mm-compaction-direct-freepage-allocation-for-async-direct-compaction.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/internal.h~mm-compaction-direct-freepage-allocation-for-async-direct-compaction-checkpatch-fixes mm/internal.h
--- a/mm/internal.h~mm-compaction-direct-freepage-allocation-for-async-direct-compaction-checkpatch-fixes
+++ a/mm/internal.h
@@ -145,7 +145,7 @@ static inline struct page *pageblock_pfn
 }
 
 extern int __isolate_free_page(struct page *page, unsigned int order);
-extern struct page * alloc_pages_zone(struct zone *zone, unsigned int order,
+extern struct page *alloc_pages_zone(struct zone *zone, unsigned int order,
 							int migratetype);
 extern void __free_pages_bootmem(struct page *page, unsigned long pfn,
 					unsigned int order);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
kernel-padata-hide-unused-functions-checkpatch-fixes.patch
mm.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-compaction-direct-freepage-allocation-for-async-direct-compaction.patch
mm-uninline-page_mapped.patch
mm-uninline-page_mapped-checkpatch-fixes.patch
memory_hotplug-introduce-config_memory_hotplug_default_online-fix.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path-fix.patch
mm-compaction-abstract-compaction-feedback-to-helpers-fix.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders-fix.patch
mm-kasan-initial-memory-quarantine-implementation-v8-fix.patch
exit_thread-remove-empty-bodies-fix.patch
exit_thread-accept-a-task-parameter-to-be-exited-checkpatch-fixes.patch
fs-execc-fix-minor-memory-leak.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

