From: akpm@linux-foundation.org
Subject: [merged] cgroups-add-li-zefan-as-a-maintainer.patch removed from -mm tree
Date: Thu, 12 Feb 2009 12:25:43 -0800
Message-ID: <200902122025.n1CKPhd6015046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757122AbZBLU0i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Feb 2009 15:26:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, mm-commits@vger.kernel.org


The patch titled
     cgroups: add Li Zefan as a maintainer
has been removed from the -mm tree.  Its filename was
     cgroups-add-li-zefan-as-a-maintainer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: add Li Zefan as a maintainer
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Add Li Zefan as co-maintainer.

Acked-by: Paul Menage <menage@google.com>
Acked-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff -puN MAINTAINERS~cgroups-add-li-zefan-as-a-maintainer MAINTAINERS
--- a/MAINTAINERS~cgroups-add-li-zefan-as-a-maintainer
+++ a/MAINTAINERS
@@ -1202,6 +1202,8 @@ S:	Supported
 CONTROL GROUPS (CGROUPS)
 P:	Paul Menage
 M:	menage@google.com
+P:	Li Zefan
+M:	lizf@cn.fujitsu.com
 L:	containers@lists.linux-foundation.org
 S:	Maintained
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
vmalloc-add-__get_vm_area_caller.patch
vmalloc-add-__get_vm_area_caller-checkpatch-fixes.patch
linux-next.patch
get_mm_hiwater_xxx-trivial-s-define-inline.patch
swsusp-clean-up-shrink_all_zones.patch
swsusp-dont-fiddle-with-swappiness.patch
vmscan-rename-scmay_swap-to-may_unmap.patch
mm-introduce-for_each_populated_zone-macro.patch
mm-introduce-for_each_populated_zone-macro-cleanup.patch
mm-dont-call-mark_page_accessed-in-do_swap_page.patch
mm-update_page_reclaim_stat-is-called-from-page-fault-path.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
memcg-remove-mem_cgroup_calc_mapped_ratio-take2.patch
memcg-remove-mem_cgroup_reclaim_imbalance-remnants.patch
ia64-implement-interrupt-enabling-rwlocks.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

