From: akpm@linux-foundation.org
Subject: + get_unmapped_area-handles-map_fixed-in-hugetlbfs-fix.patch added to -mm tree
Date: Wed, 02 May 2007 15:34:57 -0700
Message-ID: <200705022237.l42MblqA031808@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766752AbXEBWhu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 May 2007 18:37:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, benh@kernel.crashing.org


The patch titled
     get_unmapped_area-handles-map_fixed-in-hugetlbfs-fix
has been added to the -mm tree.  Its filename is
     get_unmapped_area-handles-map_fixed-in-hugetlbfs-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: get_unmapped_area-handles-map_fixed-in-hugetlbfs-fix
From: Andrew Morton <akpm@linux-foundation.org>

fs/hugetlbfs/inode.c: In function 'hugetlb_get_unmapped_area':
fs/hugetlbfs/inode.c:115: error: 'MAP_FIXED' undeclared (first use in this function)
fs/hugetlbfs/inode.c:115: error: (Each undeclared identifier is reported only once
fs/hugetlbfs/inode.c:115: error: for each function it appears in.)

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/hugetlbfs/inode.c~get_unmapped_area-handles-map_fixed-in-hugetlbfs-fix fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~get_unmapped_area-handles-map_fixed-in-hugetlbfs-fix
+++ a/fs/hugetlbfs/inode.c
@@ -22,6 +22,7 @@
 #include <linux/backing-dev.h>
 #include <linux/hugetlb.h>
 #include <linux/pagevec.h>
+#include <linux/mman.h>
 #include <linux/quotaops.h>
 #include <linux/slab.h>
 #include <linux/dnotify.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slab-introduce-krealloc.patch
rm9000-serial-driver.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
smaps-add-clear_refs-file-to-clear-reference.patch
slab-mark-set_up_list3s-__init.patch
slub-core.patch
mm-optimize-kill_bdev.patch
lazy-freeing-of-memory-through-madv_free.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
uml-driver-formatting-fixes-fix.patch
get_unmapped_area-handles-map_fixed-in-hugetlbfs-fix.patch
