From: akpm@linux-foundation.org
Subject: +
 mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone-checkpatch-fixes.patch added to -mm tree
Date: Mon, 21 Apr 2014 15:06:48 -0700
Message-ID: <53559678.iVXcEeZB4NMuwk/A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37268 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbaDUWGt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 18:06:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, nasa4836@gmail.com, akpm@linux-foundation.org

Subject: + mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone-checkpatch-fixes.patch added to -mm tree
To: akpm@linux-foundation.org,nasa4836@gmail.com
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 15:06:48 -0700


The patch titled
     Subject: mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone-checkpatch-fixes

WARNING: please, no spaces at the start of a line
#29: FILE: mm/memcontrol.c:689:
+       int nid = zone_to_nid(zone);$

WARNING: please, no spaces at the start of a line
#30: FILE: mm/memcontrol.c:690:
+       int zid = zone_idx(zone);$

WARNING: please, no spaces at the start of a line
#32: FILE: mm/memcontrol.c:692:
+       return mem_cgroup_zoneinfo(memcg, nid, zid);$

total: 0 errors, 3 warnings, 35 lines checked

./patches/mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jianyu Zhan <nasa4836@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone-checkpatch-fixes mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone-checkpatch-fixes
+++ a/mm/memcontrol.c
@@ -686,10 +686,10 @@ mem_cgroup_zoneinfo(struct mem_cgroup *m
 static struct mem_cgroup_per_zone *
 mem_cgroup_zoneinfo_zone(struct mem_cgroup *memcg, struct zone *zone)
 {
-       int nid = zone_to_nid(zone);
-       int zid = zone_idx(zone);
+	int nid = zone_to_nid(zone);
+	int zid = zone_idx(zone);
 
-       return mem_cgroup_zoneinfo(memcg, nid, zid);
+	return mem_cgroup_zoneinfo(memcg, nid, zid);
 }
 
 struct cgroup_subsys_state *mem_cgroup_css(struct mem_cgroup *memcg)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-limit-printk-when-journal-is-aborted-fix.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage-fix.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-gupc-tweaks.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

