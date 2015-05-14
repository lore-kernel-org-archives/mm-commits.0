From: akpm@linux-foundation.org
Subject: [folded-merged] gfp-add-__gfp_noaccount-v2-fix.patch removed from -mm tree
Date: Thu, 14 May 2015 15:14:03 -0700
Message-ID: <55551e2b.IYb8PZCTBZjEqtrK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50463 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422694AbbENWOE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 May 2015 18:14:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.cz, tj@kernel.org, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: gfp-add-__gfp_noaccount-v2-fix
has been removed from the -mm tree.  Its filename was
     gfp-add-__gfp_noaccount-v2-fix.patch

This patch was dropped because it was folded into gfp-add-__gfp_noaccount.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: gfp-add-__gfp_noaccount-v2-fix

revert the WARN_ON

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/memcontrol.c~gfp-add-__gfp_noaccount-v2-fix mm/memcontrol.c
--- a/mm/memcontrol.c~gfp-add-__gfp_noaccount-v2-fix
+++ a/mm/memcontrol.c
@@ -5462,8 +5462,6 @@ int mem_cgroup_try_charge(struct page *p
 	unsigned int nr_pages = 1;
 	int ret = 0;
 
-	WARN_ON_ONCE(gfp_mask & __GFP_NOACCOUNT);
-
 	if (mem_cgroup_disabled())
 		goto out;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-rtc-rtc-armada38xc-remove-unused-local-flags.patch
gfp-add-__gfp_noaccount.patch
cma-page_isolation-check-buddy-before-access-it-fix.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix.patch
mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix.patch
mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix-2.patch
mm-clarify-that-the-function-operateds-on-hugepage-pte-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
proc-fix-page_size-limit-of-proc-pid-cmdline-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
radix-tree-replace-preallocated-node-array-with-linked-list-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
linux-next.patch
linux-next-rejects.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

