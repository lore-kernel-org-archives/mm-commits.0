From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-compaction-always-update-cached-scanner-positions-fix-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 10 Dec 2014 15:15:28 -0800
Message-ID: <5488d410.tjQxV6WniTn1e5c0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758166AbaLJXP3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Dec 2014 18:15:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-always-update-cached-scanner-positions-fix-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-compaction-always-update-cached-scanner-positions-fix-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-compaction-always-update-cached-scanner-positions.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-compaction-always-update-cached-scanner-positions-fix-checkpatch-fixes

WARNING: Missing a blank line after declarations
#65: FILE: mm/compaction.c:1243:
+		unsigned long free_pfn = release_freepages(&cc->freepages);
+		cc->nr_freepages = 0;

total: 0 errors, 1 warnings, 47 lines checked

./patches/mm-compaction-always-update-cached-scanner-positions-fix.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-always-update-cached-scanner-positions-fix-checkpatch-fixes mm/compaction.c
--- a/mm/compaction.c~mm-compaction-always-update-cached-scanner-positions-fix-checkpatch-fixes
+++ a/mm/compaction.c
@@ -1245,8 +1245,8 @@ out:
 	 */
 	if (cc->nr_freepages > 0) {
 		unsigned long free_pfn = release_freepages(&cc->freepages);
-		cc->nr_freepages = 0;
 
+		cc->nr_freepages = 0;
 		VM_BUG_ON(free_pfn == 0);
 		/* The cached pfn is always the first in a pageblock */
 		free_pfn &= ~(pageblock_nr_pages-1);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cma-fix-boot-regression-due-to-physical-address-of-high_memory.patch
slab-improve-checking-for-invalid-gfp_flags.patch
mm-memcontrol-lockless-page-counters.patch
kernel-res_counter-remove-the-unused-api.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
mm-fix-huge-zero-page-accounting-in-smaps-report-fix-2-fix.patch
fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch
fs-binfmt_miscc-use-gfp_kernel-instead-of-gfp_user.patch
init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes.patch
rtc-omap-add-support-for-pmic_power_en-v3-fix.patch
drivers-rtc-rtc-sirfsocc-add-alarm_irq_enable-support-fix.patch
rtc-ds1374-add-watchdog-support-fix.patch
rtc-ds1374-add-watchdog-support-checkpatch-fixes.patch
exit-wait-cleanup-the-ptrace_reparented-checks-fix.patch

