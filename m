From: akpm@linux-foundation.org
Subject: +
 mm-memcg-decouple-elowmin-state-mutations-from-protection-checks-fix.patch
 added to -mm tree
Date: Wed, 29 Apr 2020 18:02:02 -0700
Message-ID: <20200430010202.kgzA8ArbO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726309AbgD3BCD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 29 Apr 2020 21:02:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org, laoar.shao@gmail.com, lkp@intel.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcg-decouple-elowmin-state-mutations-from-protection-checks-fix
has been added to the -mm tree.  Its filename is
     mm-memcg-decouple-elowmin-state-mutations-from-protection-checks-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-decouple-elowmin-state-mutations-from-protection-checks-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-decouple-elowmin-state-mutations-from-protection-checks-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-decouple-elowmin-state-mutations-from-protection-checks-fix

remove stray semicolon, half-written function

Reported-by: kbuild test robot <lkp@intel.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-decouple-elowmin-state-mutations-from-protection-checks-fix
+++ a/include/linux/memcontrol.h
@@ -847,13 +847,8 @@ static inline void memcg_memory_event_mm
 {
 }
 
-static inline unsigned long mem_cgroup_protection(struct mem_cgroup *memcg,
-						  bool in_low_reclaim)
-{
-
-
 static inline void mem_cgroup_calculate_protection(struct mem_cgroup *root,
-						   struct mem_cgroup *memcg);
+						   struct mem_cgroup *memcg)
 {
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memcg-fix-error-return-value-of-mem_cgroup_css_alloc-fix.patch
squashfs-migrate-from-ll_rw_block-usage-to-bio-fix.patch
drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-slub-fix-corrupted-freechain-in-deactivate_slab-fix.patch
mm-gupc-updating-the-documentation-fix.patch
mm-memcg-decouple-elowmin-state-mutations-from-protection-checks-fix.patch
mm-remove-__vmalloc_node_flags_caller-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix.patch
mm-switch-the-test_vmalloc-module-to-use-__vmalloc_node-fix-fix.patch
mm-remove-vmalloc_user_node_flags-fix.patch
mm-add-debug_wx-support-fixpatch-added-to-mm-tree.patch
riscv-support-debug_wx-fix.patch
mm-replace-zero-length-array-with-flexible-array-member-fix.patch
mm-hugetlb-fix-a-typo-in-comment-manitained-maintained-v2-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-fix.patch
mm-pass-task-and-mm-to-do_madvise-fix-fix.patch
mm-pass-task-and-mm-to-do_madvise-fix-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
