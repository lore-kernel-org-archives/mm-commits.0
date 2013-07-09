From: akpm@linux-foundation.org
Subject: [merged]
 include-linux-gfph-fix-the-comment-for-gfp_zone_table.patch removed from
 -mm tree
Date: Tue, 09 Jul 2013 16:19:47 -0700
Message-ID: <51dc9a93.6AnzkQP+8UU2OoDi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38851 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab3GIXTr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:19:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com

Subject: [merged] include-linux-gfph-fix-the-comment-for-gfp_zone_table.patch removed from -mm tree
To: zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:19:47 -0700


The patch titled
     Subject: include/linux/gfp.h: fix the comment for GFP_ZONE_TABLE
has been removed from the -mm tree.  Its filename was
     include-linux-gfph-fix-the-comment-for-gfp_zone_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: include/linux/gfp.h: fix the comment for GFP_ZONE_TABLE

0xc just means MOVABLE + DMA32, which results in zone DMA32.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/gfp.h~include-linux-gfph-fix-the-comment-for-gfp_zone_table include/linux/gfp.h
--- a/include/linux/gfp.h~include-linux-gfph-fix-the-comment-for-gfp_zone_table
+++ a/include/linux/gfp.h
@@ -209,7 +209,7 @@ static inline int allocflags_to_migratet
  *       0x9    => DMA or NORMAL (MOVABLE+DMA)
  *       0xa    => MOVABLE (Movable is valid only if HIGHMEM is set too)
  *       0xb    => BAD (MOVABLE+HIGHMEM+DMA)
- *       0xc    => DMA32 (MOVABLE+HIGHMEM+DMA32)
+ *       0xc    => DMA32 (MOVABLE+DMA32)
  *       0xd    => BAD (MOVABLE+DMA32+DMA)
  *       0xe    => BAD (MOVABLE+DMA32+HIGHMEM)
  *       0xf    => BAD (MOVABLE+DMA32+HIGHMEM+DMA)
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

origin.patch
linux-next.patch

