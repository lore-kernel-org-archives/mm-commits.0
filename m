From: akpm@linux-foundation.org
Subject: [merged] mm-memcontrolc-uninline-mem_cgroup_usage.patch removed
 from -mm tree
Date: Mon, 09 Nov 2015 11:44:48 -0800
Message-ID: <5640f7b0.Zv8If+hclt84eBGM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57135 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbbKITos (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:44:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: uninline mem_cgroup_usage
has been removed from the -mm tree.  Its filename was
     mm-memcontrolc-uninline-mem_cgroup_usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/memcontrol.c: uninline mem_cgroup_usage

gcc version 5.2.1 20151010 (Debian 5.2.1-22)
$ size mm/memcontrol.o mm/memcontrol.o.before
   text    data     bss     dec     hex filename
  35535    7908      64   43507    a9f3 mm/memcontrol.o
  35762    7908      64   43734    aad6 mm/memcontrol.o.before

Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcontrolc-uninline-mem_cgroup_usage mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrolc-uninline-mem_cgroup_usage
+++ a/mm/memcontrol.c
@@ -2801,7 +2801,7 @@ static unsigned long tree_stat(struct me
 	return val;
 }
 
-static inline unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
+static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
 {
 	unsigned long val;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
mm-increase-swap_cluster_max-to-batch-tlb-flushes-fix-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-arm-fix.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
remove-abs64-fix-fix.patch
remove-abs64-fix-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

