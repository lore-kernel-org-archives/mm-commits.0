From: akpm@linux-foundation.org
Subject: [folded-merged] memcg-add-memorypressure_level-events-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 29 Apr 2013 14:54:19 -0700
Message-ID: <20130429215419.B31745A41E9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:58943 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933202Ab3D2VyU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 17:54:20 -0400
Received: by mail-qc0-f202.google.com with SMTP id k26so713912qcs.5
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 14:54:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anton.vorontsov@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-add-memorypressure_level-events-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     memcg-add-memorypressure_level-events-checkpatch-fixes.patch

This patch was dropped because it was folded into memcg-add-memorypressure_level-events.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-add-memorypressure_level-events-checkpatch-fixes

WARNING: static const char * array should probably be static const char * const
#411: FILE: mm/vmpressure.c:100:
+static const char *vmpressure_str_levels[] = {

total: 0 errors, 1 warnings, 609 lines checked

./patches/memcg-add-memorypressure_level-events.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmpressure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmpressure.c~memcg-add-memorypressure_level-events-checkpatch-fixes mm/vmpressure.c
--- a/mm/vmpressure.c~memcg-add-memorypressure_level-events-checkpatch-fixes
+++ a/mm/vmpressure.c
@@ -97,7 +97,7 @@ enum vmpressure_levels {
 	VMPRESSURE_NUM_LEVELS,
 };
 
-static const char *vmpressure_str_levels[] = {
+static const char * const vmpressure_str_levels[] = {
 	[VMPRESSURE_LOW] = "low",
 	[VMPRESSURE_MEDIUM] = "medium",
 	[VMPRESSURE_CRITICAL] = "critical",
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
auditsc-use-kzalloc-instead-of-kmallocmemset.patch
kernel-audit_treec-tree-will-leak-memory-when-failure-occurs-in-audit_trim_trees.patch
mm-shmemc-remove-an-ifdef.patch
memcg-relax-memcg-iter-caching.patch
mm-hugetlb-add-more-arch-defined-huge_pte-functions.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation.patch
kexec-vmalloc-export-additional-vmalloc-layer-information.patch
mm-hugetlb-include-hugepages-in-meminfo.patch
mm-speedup-in-__early_pfn_to_nid.patch
include-linux-memoryh-implement-register_hotmemory_notifier.patch
ipc-utilc-use-register_hotmemory_notifier.patch
mm-slubc-use-register_hotmemory_notifier.patch
drivers-base-nodec-switch-to-register_hotmemory_notifier.patch
fs-proc-kcorec-use-register_hotmemory_notifier.patch
kernel-cpusetc-use-register_hotmemory_notifier.patch
mm-limit-growth-of-3%-hardcoded-other-user-reserve.patch
mm-replace-hardcoded-3%-with-admin_reserve_pages-knob.patch
mm-reinititalise-user-and-admin-reserves-if-memory-is-added-or-removed.patch
resource-add-release_mem_region_adjustable.patch
mm-madvise-complete-input-validation-before-taking-lock.patch
clear_refs-sanitize-accepted-commands-declaration.patch
memcg-add-memorypressure_level-events.patch
memcg-add-memorypressure_level-events-fix.patch
mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim-fix-fix.patch
thp-fix-huge-zero-page-logic-for-page-with-pfn-==-0-fix.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix.patch
mm-swap-mark-swap-pages-writeback-before-queueing-for-direct-io-fix-fix.patch
mem-hotunplug-fix-kfree-of-bootmem-memory-fix.patch

