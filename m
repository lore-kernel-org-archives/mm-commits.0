From: akpm@linux-foundation.org
Subject: [folded] mm-memcg-clean-up-fault-accounting-fix.patch removed from -mm tree
Date: Thu, 12 Jan 2012 16:46:49 -0800
Message-ID: <20120113004650.29E0F20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:33315 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690Ab2AMAqw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jan 2012 19:46:52 -0500
Received: by wgbdt14 with SMTP id dt14so80115wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jan 2012 16:46:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcg: clean up fault accounting fix
has been removed from the -mm tree.  Its filename was
     mm-memcg-clean-up-fault-accounting-fix.patch

This patch was dropped because it was folded into mm-memcg-clean-up-fault-accounting.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcg: clean up fault accounting fix

Signed-off-by: Knucklehead <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memcontrol.c~mm-memcg-clean-up-fault-accounting-fix mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-clean-up-fault-accounting-fix
+++ a/mm/memcontrol.c
@@ -968,10 +968,10 @@ void mem_cgroup_count_vm_event(struct mm
 		goto out;
 
 	switch (idx) {
-	case PGMAJFAULT:
+	case PGFAULT:
 		this_cpu_inc(memcg->stat->events[MEM_CGROUP_EVENTS_PGFAULT]);
 		break;
-	case PGFAULT:
+	case PGMAJFAULT:
 		this_cpu_inc(memcg->stat->events[MEM_CGROUP_EVENTS_PGMAJFAULT]);
 		break;
 	default:
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
memcg-fix-pgpgin-pgpgout-documentation.patch
mm-memcg-clean-up-fault-accounting.patch
mm-page_cgroup-check-page_cgroup-arrays-in-lookup_page_cgroup-only-when-necessary.patch
page_cgroup-add-helper-function-to-get-swap_cgroup-cleanup.patch
memcg-clean-up-soft_limit_tree-if-allocation-fails.patch
oom-memcg-fix-exclusion-of-memcg-threads-after-they-have-detached-their-mm.patch
memcg-simplify-page-cache-charging.patch
memcg-simplify-corner-case-handling-of-lru.patch
memcg-clear-pc-mem_cgorup-if-necessary.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-2.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-2-fix.patch
memcg-clear-pc-mem_cgorup-if-necessary-comments.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-3.patch
memcg-clear-pc-mem_cgorup-if-necessary-fix-page-migration-to-reset_owner.patch
memcg-simplify-lru-handling-by-new-rule.patch
memcg-simplify-lru-handling-by-new-rule-fix.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix-null-mem_cgroup_try_charge.patch
memcg-cleanup-for_each_node_state.patch
page_alloc-break-early-in-check_for_regular_memory.patch
page_cgroup-drop-multi-config_memory_hotplug.patch
vmscan-trace-add-file-info-to-trace_mm_vmscan_lru_isolate.patch
memcg-fix-split_huge_page_refcounts.patch
memcg-fix-mem_cgroup_print_bad_page.patch
mm-rearrange-putback_inactive_pages.patch

