From: akpm@linux-foundation.org
Subject: [folded] mm-hugetlb-add-new-hugetlb-cgroup-mark-root_h_cgroup-static.patch removed from -mm tree
Date: Tue, 31 Jul 2012 16:21:54 -0700
Message-ID: <20120731232154.B6A36A0114@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:41716 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab2GaXVz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 19:21:55 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4815521obb.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 16:21:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, wfg@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb/cgroup: Mark root_h_cgroup static
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-new-hugetlb-cgroup-mark-root_h_cgroup-static.patch

This patch was dropped because it was folded into mm-hugetlb-add-new-hugetlb-cgroup.patch

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: hugetlb/cgroup: Mark root_h_cgroup static

Fixes sparse warning reported by Fengguang Wu

Reported-by: Fengguang Wu <wfg@linux.intel.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb_cgroup.c~mm-hugetlb-add-new-hugetlb-cgroup-mark-root_h_cgroup-static mm/hugetlb_cgroup.c
--- a/mm/hugetlb_cgroup.c~mm-hugetlb-add-new-hugetlb-cgroup-mark-root_h_cgroup-static
+++ a/mm/hugetlb_cgroup.c
@@ -27,7 +27,7 @@ struct hugetlb_cgroup {
 };
 
 struct cgroup_subsys hugetlb_subsys __read_mostly;
-struct hugetlb_cgroup *root_h_cgroup __read_mostly;
+static struct hugetlb_cgroup *root_h_cgroup __read_mostly;
 
 static inline
 struct hugetlb_cgroup *hugetlb_cgroup_from_css(struct cgroup_subsys_state *s)
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

origin.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlb-dont-use-err_ptr-with-vm_fault-values.patch
hugetlb-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-add-a-list-for-tracking-in-use-hugetlb-pages.patch
hugetlb-make-some-static-variables-global.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup-fix.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup-add-huge_page_order-check-to-avoid-incorrectly-uncharge.patch
hugetlb-cgroup-add-support-for-cgroup-removal.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files-fix-fix.patch
hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-cgroup-add-hugetlb-controller-documentation.patch
hugetlb-move-all-the-in-use-pages-to-active-list.patch
hugetlb-cgroup-assign-the-page-hugetlb-cgroup-when-we-move-the-page-to-active-list.patch
hugetlb-cgroup-remove-exclude-and-wakeup-rmdir-calls-from-migrate.patch
memcg-rename-config-variables.patch
memcg-rename-config-variables-fix.patch
memcg-rename-config-variables-fix-fix.patch
linux-next.patch

