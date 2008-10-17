From: akpm@linux-foundation.org
Subject: + memcg-allocate-all-page_cgroup-at-boot-fixpatch.patch added to -mm tree
Date: Thu, 16 Oct 2008 18:57:47 -0700
Message-ID: <200810170157.m9H1vlw0024506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751340AbYJQB5y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 21:57:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memcg-allocate-all-page_cgroup-at-boot-fix.patch
has been added to the -mm tree.  Its filename is
     memcg-allocate-all-page_cgroup-at-boot-fixpatch.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-allocate-all-page_cgroup-at-boot-fix.patch
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

compile fix to memcg-allocate-all-page_cgroup-at-boot.patch

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Makefile |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/Makefile~memcg-allocate-all-page_cgroup-at-boot-fixpatch mm/Makefile
--- a/mm/Makefile~memcg-allocate-all-page_cgroup-at-boot-fixpatch
+++ a/mm/Makefile
@@ -33,5 +33,4 @@ obj-$(CONFIG_FS_XIP) += filemap_xip.o
 obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_SMP) += allocpercpu.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
-obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o
-
+obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o page_cgroup.o
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
vmscan-split-lru-lists-into-anon-file-sets-memcg-fix-handling-of-shmem-migrationv2.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-remember-pages-active-state.patch
unevictable-lru-infrastructure-defer-vm-event-counting.patch
unevictable-infrastructure-lru-add-event-counting-with-statistics.patch
shm_locked-pages-are-unevictable-add-event-counts-to-list-scan.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmstat-mlocked-pages-statistics-mlocked-pages-add-event-counting-with-statistics.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
setup_per_zone_pages_min-take-zone-lock-instead-of-zone-lru_lock.patch
documentation-clarify-dirty_ratio-and-dirty_background_ratio-description-v2.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-cgroups-eliminate-race-in-css_set-refcounting.patch
cgroups-convert-tasks-file-to-use-a-seq_file-with-shared-pid-array.patch
memcg-move-charge-swapin-under-lock.patch
memcg-make-page-mapping-null-before-uncharge.patch
memcg-avoid-accounting-special-pages.patch
memcg-optimize-per-cpu-statistics.patch
memcg-atomic-ops-for-page_cgroup-flags.patch
memcg-allocate-all-page_cgroup-at-boot.patch
memcg-allocate-all-page_cgroup-at-boot-fixpatch.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-setup-the-memrlimit-controller-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch

