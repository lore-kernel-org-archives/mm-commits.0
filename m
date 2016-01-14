From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-4.patch
 removed from -mm tree
Date: Thu, 14 Jan 2016 14:39:07 -0800
Message-ID: <5698238b.6e0RA1vnDDkMYRXz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46089 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361AbcANWjI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:39:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-4
has been removed from the -mm tree.  Its filename was
     mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-4.patch

This patch was dropped because it was folded into mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-4



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/rmap.c~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-4 mm/rmap.c
--- a/mm/rmap.c~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix-4
+++ a/mm/rmap.c
@@ -1170,7 +1170,6 @@ void do_page_add_anon_rmap(struct page *
 			atomic_inc(&page->_mapcount);
 		}
 	} else {
-		VM_BUG_ON_PAGE(compound, page);
 		first = atomic_inc_and_test(&page->_mapcount);
 	}
 
_

Patches currently in -mm which might be from kirill@shutemov.name are

mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps.patch
thp-reintroduce-split_huge_page-fix-2.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix.patch
thp-increase-split_huge_page-success-rate-fix.patch
mm-add-page_check_address_transhuge-helper-fix-fix.patch

