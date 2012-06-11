From: akpm@linux-foundation.org
Subject: [to-be-updated] hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix-2.patch removed from -mm tree
Date: Mon, 11 Jun 2012 14:10:19 -0700
Message-ID: <20120611211019.547F7A0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:46917 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab2FKVKU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 17:10:20 -0400
Received: by vbnl22 with SMTP id l22so412460vbn.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 14:10:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages-fix-2
has been removed from the -mm tree.  Its filename was
     hugetlb-migrate-memcg-info-from-oldpage-to-new-page-during-migration-fix-2.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -433,8 +433,8 @@ extern int mem_cgroup_move_hugetlb_paren
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

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
memcg-add-memory-controller-documentation-for-hugetlb-management.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2.patch
memcg-fix-error-code-in-hugetlb_force_memcg_empty-v2-checkpatch-fixes.patch
memcg-use-res_counter_uncharge_until-in-mem_cgroup_move_hugetlb_parent.patch
memcg-move-charges-to-root-cgroup-if-use_hierarchy=0-in-mem_cgroup_move_hugetlb_parent.patch

