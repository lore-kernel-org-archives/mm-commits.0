From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch removed from -mm tree
Date: Thu, 14 Jan 2016 14:40:40 -0800
Message-ID: <569823e8.dyuc81ZtoTK3oU0f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986AbcANWkl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:40:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hwpoison-adjust-for-new-thp-refcounting-fix
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch

This patch was dropped because it was folded into mm-hwpoison-adjust-for-new-thp-refcounting.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hwpoison-adjust-for-new-thp-refcounting-fix

remove unneeeeded #define, per Kirill

Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/mm.h~mm-hwpoison-adjust-for-new-thp-refcounting-fix include/linux/mm.h
--- a/include/linux/mm.h~mm-hwpoison-adjust-for-new-thp-refcounting-fix
+++ a/include/linux/mm.h
@@ -2218,7 +2218,6 @@ extern void memory_failure_queue(unsigne
 extern int unpoison_memory(unsigned long pfn);
 extern int get_hwpoison_page(struct page *page);
 #define put_hwpoison_page(page)	put_page(page)
-extern void put_hwpoison_page(struct page *page);
 extern int sysctl_memory_failure_early_kill;
 extern int sysctl_memory_failure_recovery;
 extern void shake_page(struct page *p, int access);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
mm-hwpoison-adjust-for-new-thp-refcounting.patch
thp-reintroduce-split_huge_page-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
thp-add-debugfs-handle-to-split-all-huge-pages-fix.patch

