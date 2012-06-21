From: akpm@linux-foundation.org
Subject: + mm-hugetlb-add-new-hugetlb-cgroup-mark-root_h_cgroup-static.patch added to -mm tree
Date: Thu, 21 Jun 2012 12:47:17 -0700
Message-ID: <20120621194717.A886AA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:40737 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab2FUTrS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 15:47:18 -0400
Received: by yenl3 with SMTP id l3so99803yen.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 12:47:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aneesh.kumar@linux.vnet.ibm.com, wfg@linux.intel.com


The patch titled
     Subject: hugetlb/cgroup: Mark root_h_cgroup static
has been added to the -mm tree.  Its filename is
     mm-hugetlb-add-new-hugetlb-cgroup-mark-root_h_cgroup-static.patch

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
Subject: Subject: hugetlb/cgroup: Mark root_h_cgroup static

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

linux-next.patch
hugetlb-rename-max_hstate-to-hugetlb_max_hstate.patch
hugetlb-dont-use-err_ptr-with-vm_fault-values.patch
hugetlb-add-an-inline-helper-for-finding-hstate-index.patch
hugetlb-use-mmu_gather-instead-of-a-temporary-linked-list-for-accumulating-pages.patch
hugetlb-avoid-taking-i_mmap_mutex-in-unmap_single_vma-for-hugetlb.patch
hugetlb-simplify-migrate_huge_page.patch
hugetlb-add-a-list-for-tracking-in-use-hugetlb-pages.patch
hugetlb-make-some-static-variables-global.patch
hugetlb-make-some-static-variables-global-mark-hugelb_max_hstate-__read_mostly.patch
mm-hugetlb-add-new-hugetlb-cgroup.patch
mm-hugetlb-add-new-hugetlb-cgroup-mark-root_h_cgroup-static.patch
hugetlb-cgroup-add-the-cgroup-pointer-to-page-lru.patch
hugetlb-cgroup-add-charge-uncharge-routines-for-hugetlb-cgroup.patch
hugetlb-cgroup-add-support-for-cgroup-removal.patch
hugetlb-cgroup-add-hugetlb-cgroup-control-files.patch
hugetlb-cgroup-migrate-hugetlb-cgroup-info-from-oldpage-to-new-page-during-migration.patch
hugetlb-cgroup-add-hugetlb-controller-documentation.patch
hugetlb-move-all-the-in-use-pages-to-active-list.patch
hugetlb-cgroup-assign-the-page-hugetlb-cgroup-when-we-move-the-page-to-active-list.patch
hugetlb-cgroup-remove-exclude-and-wakeup-rmdir-calls-from-migrate.patch

