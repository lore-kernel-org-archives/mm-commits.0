From: akpm@linux-foundation.org
Subject: [folded-merged] thp-reintroduce-split_huge_page-fix.patch removed from -mm tree
Date: Thu, 14 Jan 2016 14:41:15 -0800
Message-ID: <5698240b.jBoelPhv7WYvR13I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46244 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbcANWlP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:41:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp-reintroduce-split_huge_page-fix
has been removed from the -mm tree.  Its filename was
     thp-reintroduce-split_huge_page-fix.patch

This patch was dropped because it was folded into thp-reintroduce-split_huge_page.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: thp-reintroduce-split_huge_page-fix

make thp-reintroduce-split_huge_page.patch work without mm-make-optimistic-check-for-swapin-readahead.patch

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/huge_mm.h~thp-reintroduce-split_huge_page-fix include/linux/huge_mm.h
diff -puN include/linux/pagemap.h~thp-reintroduce-split_huge_page-fix include/linux/pagemap.h
diff -puN mm/huge_memory.c~thp-reintroduce-split_huge_page-fix mm/huge_memory.c
--- a/mm/huge_memory.c~thp-reintroduce-split_huge_page-fix
+++ a/mm/huge_memory.c
@@ -16,6 +16,7 @@
 #include <linux/swap.h>
 #include <linux/shrinker.h>
 #include <linux/mm_inline.h>
+#include <linux/swapops.h>
 #include <linux/dax.h>
 #include <linux/kthread.h>
 #include <linux/khugepaged.h>
diff -puN mm/internal.h~thp-reintroduce-split_huge_page-fix mm/internal.h
diff -puN mm/rmap.c~thp-reintroduce-split_huge_page-fix mm/rmap.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
thp-reintroduce-split_huge_page.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
thp-add-debugfs-handle-to-split-all-huge-pages-fix.patch

