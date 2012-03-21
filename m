From: akpm@linux-foundation.org
Subject: [folded] memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 21 Mar 2012 16:23:36 -0700
Message-ID: <20120321232336.A0583A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:57327 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756405Ab2CUXXj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2012 19:23:39 -0400
Received: by laai8 with SMTP id i8so82209laa.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Mar 2012 16:23:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch

This patch was dropped because it was folded into memcg-remove-pcg_cache-page_cgroup-flag.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes

Cc: Hugh Dickins <hughd@google.com>

ERROR: code indent should use tabs where possible
#206: FILE: mm/memcontrol.c:3283:
+                     : MEM_CGROUP_CHARGE_TYPE_CACHE);$

WARNING: please, no spaces at the start of a line
#206: FILE: mm/memcontrol.c:3283:
+                     : MEM_CGROUP_CHARGE_TYPE_CACHE);$

total: 1 errors, 1 warnings, 172 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/memcg-remove-pcg_cache-page_cgroup-flag.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes
+++ a/mm/memcontrol.c
@@ -3299,7 +3299,7 @@ void mem_cgroup_end_migration(struct mem
 	anon = PageAnon(used);
 	__mem_cgroup_uncharge_common(unused,
 		anon ? MEM_CGROUP_CHARGE_TYPE_MAPPED
-                     : MEM_CGROUP_CHARGE_TYPE_CACHE);
+		     : MEM_CGROUP_CHARGE_TYPE_CACHE);
 
 	/*
 	 * If a page is a file cache, radix-tree replacement is very atomic
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode.patch
fs-nameic-fix-warnings-on-32-bit.patch
make-swapin-readahead-skip-over-holes.patch
vmscan-kswapd-carefully-call-compaction.patch
mm-compaction-make-compact_control-order-signed.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
thp-optimize-away-unnecessary-page-table-locking.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem.patch
procfs-mark-thread-stack-correctly-in-proc-pid-maps.patch
mm-fix-move-migrate_pages-race-on-task-struct.patch
bootmem-sparsemem-remove-limit-constraint-in-alloc_bootmem_section.patch
hugetlbfs-fix-alignment-of-huge-page-requests.patch
hugetlbfs-return-error-code-when-initializing-module.patch
mmapc-fix-comment-for-__insert_vm_struct.patch
memcg-remove-pcg_cache-page_cgroup-flag.patch
memcg-simplify-move_account-check-fix.patch
memcg-use-new-logic-for-page-stat-accounting-fix.patch
memcg-fix-performance-of-mem_cgroup_begin_update_page_stat-fix.patch
mm-memcontrolc-s-stealed-stolen.patch
thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage-fix.patch

