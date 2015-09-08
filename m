From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 14:42:52 -0700
Message-ID: <55ef565c.ZvsXx3oxQtXWXu+h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53160 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbbIHVmx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 17:42:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix.patch

This patch was dropped because it was folded into mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix

fix typo in comment, use more cols

Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add-fix
+++ a/mm/hugetlb.c
@@ -339,15 +339,13 @@ out_locked:
  * so that the subsequent region_add call will have all the
  * regions it needs and will not fail.
  *
- * Upon entry, region_chg will also examine the cache of
- * region descriptors associated with the map.  If there
- * not enough descriptors cached, one will be allocated
- * for the in progress add operation.
+ * Upon entry, region_chg will also examine the cache of region descriptors
+ * associated with the map.  If there are not enough descriptors cached, one
+ * will be allocated for the in progress add operation.
  *
- * Returns the number of huge pages that need to be added
- * to the existing reservation map for the range [f, t).
- * This number is greater or equal to zero.  -ENOMEM is
- * returned if a new file_region structure or cache entry
+ * Returns the number of huge pages that need to be added to the existing
+ * reservation map for the range [f, t).  This number is greater or equal to
+ * zero.  -ENOMEM is returned if a new file_region structure or cache entry
  * is needed and can not be allocated.
  */
 static long region_chg(struct resv_map *resv, long f, long t)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

dax-revert-userfaultfd-change.patch
mm-hugetlb-add-cache-of-descriptors-to-resv_map-for-region_add.patch
x86-use-generic-early-mem-copy-fix.patch
mm-mmap-simplify-the-failure-return-working-flow-fix.patch
zswap-dynamic-pool-creation-fix.patch

