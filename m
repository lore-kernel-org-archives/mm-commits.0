From: akpm@linux-foundation.org
Subject: + mm-memcg-clean-up-fault-accounting-fix.patch added to -mm tree
Date: Tue, 27 Dec 2011 15:02:00 -0800
Message-ID: <20111227230201.183D25C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:48908 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab1L0XCE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Dec 2011 18:02:04 -0500
Received: by eekc1 with SMTP id c1so402912eek.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Dec 2011 15:02:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, minchan@kernel.org


The patch titled
     Subject: mm: memcg: clean up fault accounting fix
has been added to the -mm tree.  Its filename is
     mm-memcg-clean-up-fault-accounting-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -973,10 +973,10 @@ void mem_cgroup_count_vm_event(struct mm
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
Subject: Subject: mm: memcg: clean up fault accounting fix

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mempolicy-refix-mbind_range-vma-issue.patch
linux-next.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
vmscan-add-task-name-to-warn_scan_unevictable-messages.patch
mm-page_alloc-generalize-order-handling-in-__free_pages_bootmem.patch
mm-bootmem-drop-superfluous-range-check-when-freeing-pages-in-bulk.patch
mm-bootmem-try-harder-to-free-pages-in-bulk.patch
memcg-add-mem_cgroup_replace_page_cache-to-fix-lru-issue.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
memcg-fix-pgpgin-pgpgout-documentation.patch
mm-memcg-clean-up-fault-accounting-fix.patch
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
memcg-simplify-lru-handling-by-new-rule.patch
memcg-simplify-lru-handling-by-new-rule-fix.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge.patch
memcg-simplify-lru-handling-by-new-rule-memcg-return-eintr-at-bypassing-try_charge-fix.patch
memcg-cleanup-for_each_node_state.patch
page_alloc-break-early-in-check_for_regular_memory.patch
page_cgroup-drop-multi-config_memory_hotplug.patch
vmscan-trace-add-file-info-to-trace_mm_vmscan_lru_isolate.patch

