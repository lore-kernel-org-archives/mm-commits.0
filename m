From: akpm@linux-foundation.org
Subject: + memcg-remove-redundant-parentheses.patch added to -mm tree
Date: Wed, 04 Apr 2012 14:37:34 -0700
Message-ID: <20120404213734.DFEC5A001B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:55963 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757127Ab2DDVhg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Apr 2012 17:37:36 -0400
Received: by qcsp5 with SMTP id p5so96639qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Apr 2012 14:37:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill@shutemov.name, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     Subject: memcg: remove redundant parentheses
has been added to the -mm tree.  Its filename is
     memcg-remove-redundant-parentheses.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: memcg: remove redundant parentheses

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-redundant-parentheses mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-redundant-parentheses
+++ a/mm/memcontrol.c
@@ -73,7 +73,7 @@ static int really_do_swap_account __init
 #endif
 
 #else
-#define do_swap_account		(0)
+#define do_swap_account		0
 #endif
 
 
@@ -112,9 +112,9 @@ enum mem_cgroup_events_target {
 	MEM_CGROUP_TARGET_NUMAINFO,
 	MEM_CGROUP_NTARGETS,
 };
-#define THRESHOLDS_EVENTS_TARGET (128)
-#define SOFTLIMIT_EVENTS_TARGET (1024)
-#define NUMAINFO_EVENTS_TARGET	(1024)
+#define THRESHOLDS_EVENTS_TARGET 128
+#define SOFTLIMIT_EVENTS_TARGET 1024
+#define NUMAINFO_EVENTS_TARGET	1024
 
 struct mem_cgroup_stat_cpu {
 	long count[MEM_CGROUP_STAT_NSTATS];
@@ -359,8 +359,8 @@ static bool move_file(void)
  * Maximum loops in mem_cgroup_hierarchical_reclaim(), used for soft
  * limit reclaim to prevent infinite loops, if they ever occur.
  */
-#define	MEM_CGROUP_MAX_RECLAIM_LOOPS		(100)
-#define	MEM_CGROUP_MAX_SOFT_LIMIT_RECLAIM_LOOPS	(2)
+#define	MEM_CGROUP_MAX_RECLAIM_LOOPS		100
+#define	MEM_CGROUP_MAX_SOFT_LIMIT_RECLAIM_LOOPS	2
 
 enum charge_type {
 	MEM_CGROUP_CHARGE_TYPE_CACHE = 0,
@@ -376,8 +376,8 @@ enum charge_type {
 #define _MEM			(0)
 #define _MEMSWAP		(1)
 #define _OOM_TYPE		(2)
-#define MEMFILE_PRIVATE(x, val)	(((x) << 16) | (val))
-#define MEMFILE_TYPE(val)	(((val) >> 16) & 0xffff)
+#define MEMFILE_PRIVATE(x, val)	((x) << 16 | (val))
+#define MEMFILE_TYPE(val)	((val) >> 16 & 0xffff)
 #define MEMFILE_ATTR(val)	((val) & 0xffff)
 /* Used for OOM nofiier */
 #define OOM_CONTROL		(0)
@@ -1977,7 +1977,7 @@ struct memcg_stock_pcp {
 	unsigned int nr_pages;
 	struct work_struct work;
 	unsigned long flags;
-#define FLUSHING_CACHED_CHARGE	(0)
+#define FLUSHING_CACHED_CHARGE	0
 };
 static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock);
 static DEFINE_MUTEX(percpu_charge_mutex);
@@ -2532,7 +2532,7 @@ static void __mem_cgroup_commit_charge(s
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 
-#define PCGF_NOCOPY_AT_SPLIT ((1 << PCG_LOCK) | (1 << PCG_MIGRATION))
+#define PCGF_NOCOPY_AT_SPLIT (1 << PCG_LOCK | 1 << PCG_MIGRATION)
 /*
  * Because tail pages are not marked as "used", set it. We're under
  * zone->lru_lock, 'splitting on pmd' and compound_lock.
_
Subject: Subject: memcg: remove redundant parentheses

Patches currently in -mm which might be from kirill@shutemov.name are

memcg-fix-broken-boolen-expression.patch
memcg-mark-more-functions-variables-as-static.patch
memcg-remove-unused-variable.patch
memcg-mark-stat-field-of-mem_cgroup-struct-as-__percpu.patch
memcg-remove-redundant-parentheses.patch

