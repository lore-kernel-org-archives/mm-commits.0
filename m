From: akpm@linux-foundation.org
Subject: - cgroups-introduce-link_css_set-to-remove-duplicate-code-fix.patch removed from -mm tree
Date: Wed, 07 Jan 2009 15:06:54 -0800
Message-ID: <200901072306.n07N6sWP025592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754431AbZAGXHI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 18:07:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     add comment for link_css_set()
has been removed from the -mm tree.  Its filename was
     cgroups-introduce-link_css_set-to-remove-duplicate-code-fix.patch

This patch was dropped because it was folded into cgroups-introduce-link_css_set-to-remove-duplicate-code.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: add comment for link_css_set()
From: Li Zefan <lizf@cn.fujitsu.com>

Add comment for link_css_set() as Paul Menage sugguested.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN kernel/cgroup.c~cgroups-introduce-link_css_set-to-remove-duplicate-code-fix kernel/cgroup.c
--- a/kernel/cgroup.c~cgroups-introduce-link_css_set-to-remove-duplicate-code-fix
+++ a/kernel/cgroup.c
@@ -384,6 +384,12 @@ static int allocate_cg_links(int count, 
 	return 0;
 }
 
+/**
+ * link_css_set - a helper function to link a css_set to a cgroup
+ * @tmp_cg_links: cg_cgroup_link objects allocated by allocate_cg_links()
+ * @cg: the css_set to be linked
+ * @cgrp: the destination cgroup
+ */
 static void link_css_set(struct list_head *tmp_cg_links,
 			 struct css_set *cg, struct cgroup *cgrp)
 {
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
cgroups-documentation-updates.patch
cgroups-remove-some-redundant-null-checks.patch
ns_cgroup-remove-unused-spinlock.patch
memcg-fix-a-typo-in-kconfig.patch
cgroups-make-root_list-contains-active-hierarchies-only.patch
cgroups-add-inactive-subsystems-to-rootnodesubsys_list.patch
cgroups-introduce-link_css_set-to-remove-duplicate-code.patch
cgroups-introduce-link_css_set-to-remove-duplicate-code-fix.patch
cgroups-make-cgroup_path-rcu-safe.patch
cgroups-make-cgroup_path-rcu-safe-fixlet.patch
devices-cgroup-allow-mkfifo.patch
memcg-reduce-size-of-mem_cgroup-by-using-nr_cpu_ids.patch
memcg-new-force_empty-to-free-pages-under-group.patch
memcg-new-force_empty-to-free-pages-under-group-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-handle-swap-caches.patch
memcg-memswap-controller-kconfig.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
memcg-synchronized-lru.patch
memcg-add-mem_cgroup_disabled.patch
memcg-add-mem_cgroup_disabled-fix.patch
memory-cgroup-hierarchy-documentation-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-fix-for-hierarchical-reclaim.patch
memory-cgroup-hierarchy-feature-selector-v4.patch
memory-cgroup-hierarchy-feature-selector-v4-fix.patch
memcg-avoid-unnecessary-system-wide-oom-killer.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
memcg-fix-reclaim-result-checks.patch
memcg-swapout-refcnt-fix.patch
memcg-fix-double-free-and-make-refcnt-sane.patch
memcg-use-css_tryget-in-memcg.patch
memcg-use-css_tryget-in-memcg-fix.patch
memcg-fix-lru-accounting-for-swapcache-v2.patch
memcg-fix-shmems-swap-accounting.patch
cgroups-add-a-per-subsystem-hierarchy_mutex.patch
cgroups-use-hierarchy_mutex-in-memory-controller.patch
cgroups-add-css_tryget.patch
cpuset-remove-on-stack-cpumask_t-in-cpuset_sprintf_cpulist.patch
cpuset-remove-on-stack-cpumask_t-in-cpuset_can_attach.patch
cpuset-convert-cpuset_attach-to-use-cpumask_var_t.patch
cpuset-dont-allocate-trial-cpuset-on-stack.patch
cpuset-convert-cpuset-cpus_allowed-to-cpumask_var_t.patch
cpuset-remove-remaining-pointers-to-cpumask_t.patch

