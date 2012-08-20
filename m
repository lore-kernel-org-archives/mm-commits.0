From: akpm@linux-foundation.org
Subject: [obsolete] remove-__gfp_no_kswapd-fixes-fix.patch removed from -mm tree
Date: Mon, 20 Aug 2012 15:57:06 -0700
Message-ID: <20120820225706.74C7B1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:35771 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102Ab2HTW5I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 18:57:08 -0400
Received: by obbwc20 with SMTP id wc20so4125683obb.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 15:57:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: remove-__gfp_no_kswapd-fixes-fix
has been removed from the -mm tree.  Its filename was
     remove-__gfp_no_kswapd-fixes-fix.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: remove-__gfp_no_kswapd-fixes-fix

Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdcore.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/mtd/mtdcore.c~remove-__gfp_no_kswapd-fixes-fix drivers/mtd/mtdcore.c
--- a/drivers/mtd/mtdcore.c~remove-__gfp_no_kswapd-fixes-fix
+++ a/drivers/mtd/mtdcore.c
@@ -1065,8 +1065,7 @@ EXPORT_SYMBOL_GPL(mtd_writev);
  * until the request succeeds or until the allocation size falls below
  * the system page size. This attempts to make sure it does not adversely
  * impact system performance, so when allocating more than one page, we
- * ask the memory allocator to avoid re-trying, swapping, writing back
- * or performing I/O.
+ * ask the memory allocator to avoid re-trying.
  *
  * Note, this function also makes sure that the allocated buffer is aligned to
  * the MTD device's min. I/O unit, i.e. the "mtd->writesize" value.
_

Patches currently in -mm which might be from minchan@kernel.org are

linux-next.patch
mm-compactionc-fix-deferring-compaction-mistake.patch
mm-have-order-0-compaction-start-near-a-pageblock-with-free-pages-v2.patch
mm-remove-__gfp_no_kswapd.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch
mm-have-order-0-compaction-start-near-a-pageblock-with-free-pages.patch
mm-compaction-abort-async-compaction-if-locks-are-contended-or-taking-too-long.patch

