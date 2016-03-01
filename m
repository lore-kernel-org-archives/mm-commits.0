From: akpm@linux-foundation.org
Subject: +
 mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3.patch added to -mm tree
Date: Tue, 01 Mar 2016 12:55:23 -0800
Message-ID: <56d601bb.oQr8xxV9m6TqqhTR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39067 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbcCAUzY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2016 15:55:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_ref: fix build failure for xtensa
has been added to the -mm tree.  Its filename is
     mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/page_ref: fix build failure for xtensa

This patch includes struct page definition to fix build failure on xtensa.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_page_ref.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/debug_page_ref.c~mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3 mm/debug_page_ref.c
--- a/mm/debug_page_ref.c~mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3
+++ a/mm/debug_page_ref.c
@@ -1,3 +1,4 @@
+#include <linux/mm_types.h>
 #include <linux/tracepoint.h>
 
 #define CREATE_TRACE_POINTS
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-slab-fix-stale-code-comment.patch
mm-slab-remove-useless-structure-define.patch
mm-slab-remove-the-checks-for-slab-implementation-bug.patch
mm-slab-activate-debug_pagealloc-in-slab-when-it-is-actually-enabled.patch
mm-slab-use-more-appropriate-condition-check-for-debug_pagealloc.patch
mm-slab-clean-up-debug_pagealloc-processing-code.patch
mm-slab-alternative-implementation-for-debug_slab_leak.patch
mm-slab-remove-object-status-buffer-for-debug_slab_leak.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page.patch
mm-slab-align-cache-size-first-before-determination-of-off_slab-candidate.patch
mm-slab-clean-up-cache-type-determination.patch
mm-slab-do-not-change-cache-size-if-debug-pagealloc-isnt-possible.patch
mm-slab-make-criteria-for-off-slab-determination-robust-and-simple.patch
mm-slab-factor-out-slab-list-fixup-code.patch
mm-slab-factor-out-debugging-initialization-in-cache_init_objs.patch
mm-slab-introduce-new-slab-management-type-objfreelist_slab.patch
mm-slab-introduce-new-slab-management-type-objfreelist_slab-fix.patch
mm-slab-avoid-returning-values-by-reference.patch
mm-slab-re-implement-pfmemalloc-support.patch
mm-slab-re-implement-pfmemalloc-support-v2.patch
mm-slub-support-left-red-zone.patch
mm-slub-support-left-red-zone-fix.patch
mm-compaction-fix-invalid-free_pfn-and-compact_cached_free_pfn.patch
mm-compaction-pass-only-pageblock-aligned-range-to-pageblock_pfn_to_page.patch
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous.patch
mm-vmalloc-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting-v2.patch
sound-query-dynamic-debug_pagealloc-setting.patch
powerpc-query-dynamic-debug_pagealloc-setting.patch
tile-query-dynamic-debug_pagealloc-setting.patch
mm-introduce-page-reference-manipulation-functions.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3.patch

