From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-remove-stale-page_cgroup_lock-comment.patch removed from -mm
 tree
Date: Thu, 11 Dec 2014 10:57:44 -0800
Message-ID: <5489e928.oCQY/ChBe8p5GSSw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45425 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758490AbaLKS5p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:57:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: remove stale page_cgroup_lock comment
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-remove-stale-page_cgroup_lock-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: remove stale page_cgroup_lock comment

There is no cgroup-specific page lock anymore.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-remove-stale-page_cgroup_lock-comment mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-remove-stale-page_cgroup_lock-comment
+++ a/mm/memcontrol.c
@@ -2467,10 +2467,6 @@ static void commit_charge(struct page *p
 	int isolated;
 
 	VM_BUG_ON_PAGE(pc->mem_cgroup, page);
-	/*
-	 * we don't need page_cgroup_lock about tail pages, becase they are not
-	 * accessed by any other context at this point.
-	 */
 
 	/*
 	 * In some cases, SwapCache and FUSE(splice_buf->radixtree), the page
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
memcg-__mem_cgroup_free-remove-stale-disarm_static_keys-comment.patch
memcg-dont-check-mm-in-__memcg_kmem_get_cachenewpage_charge.patch
memcg-do-not-abuse-memcg_kmem_skip_account.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-mincore-add-hwpoison-page-handle.patch
memcg-zap-kmem_account_flags.patch
memcg-only-check-memcg_kmem_skip_account-in-__memcg_kmem_get_cache.patch
memcg-turn-memcg_kmem_skip_account-into-a-bit-field.patch
mm-move-swp_entry_t-definition-to-include-linux-mm_typesh.patch
mm-gfp-escalatedly-define-gfp_highuser-and-gfp_highuser_movable.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging.patch
mm-page_ext-resurrect-struct-page-extending-code-for-debugging-fix.patch
mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable.patch
mm-debug-pagealloc-make-debug-pagealloc-boottime-configurable-fix.patch
mm-nommu-use-alloc_pages_exact-rather-than-its-own-implementation.patch
stacktrace-introduce-snprint_stack_trace-for-buffer-output.patch
mm-page_owner-keep-track-of-page-owners.patch
mm-page_owner-correct-owner-information-for-early-allocated-pages.patch
documentation-add-new-page_owner-document.patch
mm-vmscan-invoke-slab-shrinkers-from-shrink_zone.patch
mm-vmscan-invoke-slab-shrinkers-from-shrink_zone-fix.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
mm-memcontrol-fix-defined-but-not-used-compiler-warning.patch
memcg-fix-possible-use-after-free-in-memcg_kmem_get_cache.patch
mm-memcontrolc-cleaning-up-function-that-are-not-used-anywhere.patch

