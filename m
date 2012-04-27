From: akpm@linux-foundation.org
Subject: + hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix-2.patch added to -mm tree
Date: Fri, 27 Apr 2012 15:16:34 -0700
Message-ID: <20120427221634.4EB6AA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:36161 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab2D0WQf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Apr 2012 18:16:35 -0400
Received: by vcbfk26 with SMTP id fk26so138714vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 27 Apr 2012 15:16:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com


The patch titled
     Subject: hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-2
has been added to the -mm tree.  Its filename is
     hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-2

Remove further strange double space.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/memcontrol.h~hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix-2 include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix-2
+++ a/include/linux/memcontrol.h
@@ -464,8 +464,8 @@ extern int mem_cgroup_move_hugetlb_paren
 					  struct page *page);
 extern bool mem_cgroup_have_hugetlb_usage(struct cgroup *cgroup);
 
-extern void  mem_cgroup_hugetlb_migrate(struct page *oldhpage,
-					struct page *newhpage);
+extern void mem_cgroup_hugetlb_migrate(struct page *oldhpage,
+				       struct page *newhpage);
 #else
 static inline int
 mem_cgroup_hugetlb_charge_page(int idx, unsigned long nr_pages,
_
Subject: Subject: hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-2

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

origin.patch
linux-next.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlbfs-dont-use-err_ptr-with-vm_fault-values.patch
hugetlbfs-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-fix.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-2.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
memcg-add-hugetlb-extension.patch
memcg-add-hugetlb-extension-fix.patch
hugetlb-add-charge-uncharge-calls-for-hugetlb-alloc-free.patch
memcg-track-resource-index-in-cftype-private.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
hugetlbfs-add-a-list-for-tracking-in-use-hugetlb-pages.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix.patch
memcg-move-hugetlb-resource-count-to-parent-cgroup-on-memcg-removal-fix-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix.patch
hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix-2.patch
memcg-add-memory-controller-documentation-for-hugetlb-management.patch
lib-string_helpersc-make-arrays-static.patch

