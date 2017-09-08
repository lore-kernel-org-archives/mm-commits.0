From: akpm@linux-foundation.org
Subject: [folded-merged]
 bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix.patch removed from
 -mm tree
Date: Fri, 08 Sep 2017 16:04:31 -0700
Message-ID: <59b321ff.Lh16Ng4rJ17Ye3xs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50028 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757210AbdIHXEc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:04:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ynorov@caviumnetworks.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix
has been removed from the -mm tree.  Its filename was
     bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix.patch

This patch was dropped because it was folded into bitmap-introduce-bitmap_from_u64.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix

Cc: Yury Norov <ynorov@caviumnetworks.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bitmap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/bitmap.h~bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix include/linux/bitmap.h
--- a/include/linux/bitmap.h~bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix
+++ a/include/linux/bitmap.h
@@ -366,7 +366,7 @@ static inline int bitmap_parse(const cha
  * Linux bitmaps are internally arrays of unsigned longs, i.e. 32-bit
  * integers in 32-bit environment, and 64-bit integers in 64-bit one.
  *
- * There are four combinations of endianess and length of the word in linux
+ * There are four combinations of endianness and length of the word in linux
  * ABIs: LE64, BE64, LE32 and BE32.
  *
  * On 64-bit kernels 64-bit LE and BE numbers are naturally ordered in
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

bitmap-introduce-bitmap_from_u64.patch

