From: akpm@linux-foundation.org
Subject: [merged] mm-page-writebackc-document-bdi_min_ratio.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:08:10 -0700
Message-ID: <201111012108.pA1L8AYh011678@wpaz33.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:28576 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab1KAVIV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:08:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jweiner@redhat.com, fengguang.wu@intel.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-writeback.c: document bdi_min_ratio
has been removed from the -mm tree.  Its filename was
     mm-page-writebackc-document-bdi_min_ratio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <jweiner@redhat.com>
Subject: mm/page-writeback.c: document bdi_min_ratio

Looks like someone got distracted after adding the comment characters.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/page-writeback.c~mm-page-writebackc-document-bdi_min_ratio mm/page-writeback.c
--- a/mm/page-writeback.c~mm-page-writebackc-document-bdi_min_ratio
+++ a/mm/page-writeback.c
@@ -305,7 +305,9 @@ static unsigned long task_min_dirty_limi
 }
 
 /*
- *
+ * bdi_min_ratio keeps the sum of the minimum dirty shares of all
+ * registered backing devices, which, for obvious reasons, can not
+ * exceed 100%.
  */
 static unsigned int bdi_min_ratio;
 
_

Patches currently in -mm which might be from jweiner@redhat.com are

origin.patch
mm-add-extra-free-kbytes-tunable.patch
thp-tail-page-refcounting-fix-5.patch
powerpc-remove-superfluous-pagetail-checks-on-the-pte-gup_fast.patch
powerpc-get_hugepte-dont-put_page-the-wrong-page.patch
powerpc-gup_hugepte-avoid-to-free-the-head-page-too-many-times.patch
powerpc-gup_hugepte-support-thp-based-tail-recounting.patch
powerpc-gup_huge_pmd-return-0-if-pte-changes.patch
s390-gup_huge_pmd-support-thp-tail-recounting.patch
s390-gup_huge_pmd-return-0-if-pte-changes.patch
sparc-gup_pte_range-support-thp-based-tail-recounting.patch
thp-share-get_huge_page_tail.patch
memcg-skip-scanning-active-lists-based-on-individual-size.patch
memcg-skip-scanning-active-lists-based-on-individual-size-fix.patch
memcg-close-race-between-charge-and-putback.patch

