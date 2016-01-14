From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch
 removed from -mm tree
Date: Thu, 14 Jan 2016 14:38:58 -0800
Message-ID: <56982382.aiDOvacmKxj4/ekM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46082 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbcANWi7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:38:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix
has been removed from the -mm tree.  Its filename was
     mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix.patch

This patch was dropped because it was folded into mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix

fix typo in comment

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/page-flags.h~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps-fix
+++ a/include/linux/page-flags.h
@@ -530,7 +530,7 @@ static inline int PageTransTail(struct p
  * PageDoubleMap indicates that the compound page is mapped with PTEs as well
  * as PMDs.
  *
- * This is required for optimization of rmap oprations for THP: we can postpone
+ * This is required for optimization of rmap operations for THP: we can postpone
  * per small page mapcount accounting (and its overhead from atomic operations)
  * until the first PMD split.
  *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

include-linux-dcacheh-remove-semicolons-from-hash_len_declare.patch
fs-block_devc-bdev_write_page-use-blk_queue_enter-gfp_noio.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps.patch
mm-hwpoison-adjust-for-new-thp-refcounting-fix.patch
thp-reintroduce-split_huge_page-fix.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-checkpatch-fixes.patch
thp-add-debugfs-handle-to-split-all-huge-pages-fix.patch

