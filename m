From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlbc-defer-pageheadhuge-symbol-export.patch
 removed from -mm tree
Date: Wed, 22 Jan 2014 12:12:30 -0800
Message-ID: <52e0262e.hNAKOEGNPwgbAHhe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54309 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbaAVUMb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:12:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, pshelar@nicira.com, minchan@kernel.org, mgorman@suse.de, khalid.aziz@oracle.com, jweiner@redhat.com, gregkh@linuxfoundation.org, cl@linux.com, bhutchings@solarflare.com, andi@firstfloor.org, aarcange@redhat.com

Subject: [merged] mm-hugetlbc-defer-pageheadhuge-symbol-export.patch removed from -mm tree
To: aarcange@redhat.com,andi@firstfloor.org,bhutchings@solarflare.com,cl@linux.com,gregkh@linuxfoundation.org,jweiner@redhat.com,khalid.aziz@oracle.com,mgorman@suse.de,minchan@kernel.org,pshelar@nicira.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:12:30 -0800


The patch titled
     Subject: mm/hugetlb.c: defer PageHeadHuge() symbol export
has been removed from the -mm tree.  Its filename was
     mm-hugetlbc-defer-pageheadhuge-symbol-export.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm/hugetlb.c: defer PageHeadHuge() symbol export

No actual need of it. So keep it internal.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Pravin Shelar <pshelar@nicira.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ben Hutchings <bhutchings@solarflare.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlbc-defer-pageheadhuge-symbol-export mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlbc-defer-pageheadhuge-symbol-export
+++ a/mm/hugetlb.c
@@ -709,7 +709,6 @@ int PageHeadHuge(struct page *page_head)
 
 	return get_compound_page_dtor(page_head) == free_huge_page;
 }
-EXPORT_SYMBOL_GPL(PageHeadHuge);
 
 pgoff_t __basepage_index(struct page *page)
 {
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
mm-munlock-fix-potential-race-with-thp-page-split.patch
mm-fix-the-theoretical-compound_lock-vs-prep_new_page-race.patch

