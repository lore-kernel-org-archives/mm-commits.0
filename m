From: akpm@linux-foundation.org
Subject: [folded] mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 12 Jan 2012 16:45:31 -0800
Message-ID: <20120113004531.7261D1E0058@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:57465 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756673Ab2AMApc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2012 19:45:32 -0500
Received: by yhjj52 with SMTP id j52so6727yhj.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2012 16:45:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bsingharora@gmail.com, jweiner@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes

Cc: Balbir Singh <bsingharora@gmail.com>

WARNING: suspect code indent for conditional statements (16, 20)
#421: FILE: mm/vmscan.c:1843:
+		if (inactive_list_is_low(mz, file))
+		    shrink_active_list(nr_to_scan, mz, sc, priority, file);

total: 0 errors, 1 warnings, 599 lines checked

./patches/mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned-checkpatch-fixes
+++ a/mm/vmscan.c
@@ -1841,7 +1841,7 @@ static unsigned long shrink_list(enum lr
 
 	if (is_active_lru(lru)) {
 		if (inactive_list_is_low(mz, file))
-		    shrink_active_list(nr_to_scan, mz, sc, priority, file);
+			shrink_active_list(nr_to_scan, mz, sc, priority, file);
 		return 0;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch
drivers-video-nvidia-nvidiac-fix-warning.patch
pipe-fail-cleanly-when-root-tries-f_setpipe_sz-with-big-size.patch
mm-vmscan-distinguish-between-memcg-triggering-reclaim-and-memcg-being-scanned.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-2-fix.patch
memcg-simplify-lru-handling-by-new-rule-fix.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction-fix-fix-3.patch
mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix.patch
kexec-remove-kmsg_dump_kexec.patch
panic-dont-print-redundant-backtraces-on-oops-fix.patch
drivers-parport-parport_pcc-fix-warnings.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
selftests-new-very-basic-kernel-selftests-directory.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch
fixed-use-of-rounddown_pow_of_two-in-ramoops.patch

