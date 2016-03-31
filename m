From: akpm@linux-foundation.org
Subject: +
 mm-compaction-direct-freepage-allocation-for-async-direct-compaction-checkpatch-fixes.patch added to -mm tree
Date: Thu, 31 Mar 2016 15:13:02 -0700
Message-ID: <56fda0ee.SCPX1uLMjHq+l72N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36206 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757352AbcCaWND (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2016 18:13:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-direct-freepage-allocation-for-async-direct-compaction-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-compaction-direct-freepage-allocation-for-async-direct-compaction-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-direct-freepage-allocation-for-async-direct-compaction-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-direct-freepage-allocation-for-async-direct-compaction-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
include-linux-apply-__malloc-attribute-checkpatch-fixes.patch
include-linux-nodemaskh-create-next_node_in-helper.patch
include-linux-nodemaskh-create-next_node_in-helper-fix-fix.patch
mm-hugetlbc-use-first_memory_node.patch
mm-mempolicyc-offset_il_node-document-and-clarify.patch
mm-compaction-direct-freepage-allocation-for-async-direct-compaction-checkpatch-fixes.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

