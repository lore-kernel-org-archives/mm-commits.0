From: akpm@linux-foundation.org
Subject: [folded-merged]
 document-interaction-between-compaction-and-the-unevictable-lru-fix.patch
 removed from -mm tree
Date: Wed, 15 Apr 2015 15:35:48 -0700
Message-ID: <552ee7c4.V0Eb5XJrUgvBczAR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51836 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbbDOWft (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 18:35:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, emunson@akamai.com, mgorman@suse.de, mhocko@suse.cz, peterz@infradead.org, riel@redhat.com, rientjes@google.com, tglx@linutronix.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: document-interaction-between-compaction-and-the-unevictable-lru-fix
has been removed from the -mm tree.  Its filename was
     document-interaction-between-compaction-and-the-unevictable-lru-fix.patch

This patch was dropped because it was folded into document-interaction-between-compaction-and-the-unevictable-lru.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: document-interaction-between-compaction-and-the-unevictable-lru-fix

identify /proc/sys/vm/compact_unevictable directly

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric B Munson <emunson@akamai.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/unevictable-lru.txt |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN Documentation/vm/unevictable-lru.txt~document-interaction-between-compaction-and-the-unevictable-lru-fix Documentation/vm/unevictable-lru.txt
--- a/Documentation/vm/unevictable-lru.txt~document-interaction-between-compaction-and-the-unevictable-lru-fix
+++ a/Documentation/vm/unevictable-lru.txt
@@ -455,10 +455,11 @@ COMPACTING MLOCKED PAGES
 ------------------------
 
 The unevictable LRU can be scanned for compactable regions and the default
-behavior is to do so.  There is a sysctl to control this behavior (see
-Documentation/sysctl/vm.txt).  Once scanning of the unevictable LRU is
-enabled, the work of compaction is mostly handled by the page migration code
-and the same work flow as described in MIGRATING MLOCKED PAGES will apply.
+behavior is to do so.  /proc/sys/vm/compact_unevictable_allowed controls
+this behavior (see Documentation/sysctl/vm.txt).  Once scanning of the
+unevictable LRU is enabled, the work of compaction is mostly handled by
+the page migration code and the same work flow as described in MIGRATING
+MLOCKED PAGES will apply.
 
 
 mmap(MAP_LOCKED) SYSTEM CALL HANDLING
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
document-interaction-between-compaction-and-the-unevictable-lru.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-mmapc-use-while-instead-of-ifgoto-fix.patch
mm-hugetlb-introduce-pagehugeactive-flag-fix.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag-fix.patch
mm-memblock-add-debug-output-for-the-memblock_add-fix.patch
mm-uninline-and-cleanup-page-mapping-related-helpers-checkpatch-fixes.patch
mm-cma-add-functions-to-get-region-pages-counters-fix.patch
mm-cma_debugc-remove-blank-lines-before-define_simple_attribute.patch
mm-memory-print-also-a_ops-readpage-in-print_bad_pte-fix.patch
mm-compactionc-fix-suitable_migration_target-unused-warning.patch
zsmalloc-support-compaction-fix.patch
proc-pid-status-show-all-sets-of-pid-according-to-ns-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch

