From: akpm@linux-foundation.org
Subject: [merged] mm-fix-spelling-error.patch removed from -mm tree
Date: Thu, 04 May 2017 12:12:18 -0700
Message-ID: <20170504191218.OBY0daxt0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51610 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756334AbdEDTMT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:12:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haolee.swjtu@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix spelling error
has been removed from the -mm tree.  Its filename was
     mm-fix-spelling-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hao Lee <haolee.swjtu@gmail.com>
Subject: mm: fix spelling error

Fix variable name error in comments. No code changes.

Link: http://lkml.kernel.org/r/20170403161655.5081-1-haolee.swjtu@gmail.com
Signed-off-by: Hao Lee <haolee.swjtu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/gfp.h~mm-fix-spelling-error include/linux/gfp.h
--- a/include/linux/gfp.h~mm-fix-spelling-error
+++ a/include/linux/gfp.h
@@ -313,8 +313,8 @@ static inline bool gfpflags_allow_blocki
 
 /*
  * GFP_ZONE_TABLE is a word size bitstring that is used for looking up the
- * zone to use given the lowest 4 bits of gfp_t. Entries are ZONE_SHIFT long
- * and there are 16 of them to cover all possible combinations of
+ * zone to use given the lowest 4 bits of gfp_t. Entries are GFP_ZONES_SHIFT
+ * bits long and there are 16 of them to cover all possible combinations of
  * __GFP_DMA, __GFP_DMA32, __GFP_MOVABLE and __GFP_HIGHMEM.
  *
  * The zone fallback order is MOVABLE=>HIGHMEM=>NORMAL=>DMA32=>DMA.
_

Patches currently in -mm which might be from haolee.swjtu@gmail.com are


