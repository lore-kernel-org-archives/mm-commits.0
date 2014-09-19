From: akpm@linux-foundation.org
Subject: + blkdev-use-null-instead-of-zero.patch added to -mm tree
Date: Fri, 19 Sep 2014 15:09:17 -0700
Message-ID: <541ca98d.x3tnPAzTXbbIPVuO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757728AbaISWJS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Sep 2014 18:09:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michele.curti@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/blkdev.h: use NULL instead of zero
has been added to the -mm tree.  Its filename is
     blkdev-use-null-instead-of-zero.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/blkdev-use-null-instead-of-zero.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/blkdev-use-null-instead-of-zero.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michele Curti <michele.curti@gmail.com>
Subject: include/linux/blkdev.h: use NULL instead of zero

Quite useless but it shuts up some warnings.

Signed-off-by: Michele Curti <michele.curti@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/blkdev.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/blkdev.h~blkdev-use-null-instead-of-zero include/linux/blkdev.h
--- a/include/linux/blkdev.h~blkdev-use-null-instead-of-zero
+++ a/include/linux/blkdev.h
@@ -1564,7 +1564,7 @@ static inline int blk_rq_map_integrity_s
 }
 static inline struct blk_integrity *bdev_get_integrity(struct block_device *b)
 {
-	return 0;
+	return NULL;
 }
 static inline struct blk_integrity *blk_get_integrity(struct gendisk *disk)
 {
_

Patches currently in -mm which might be from michele.curti@gmail.com are

blkdev-use-null-instead-of-zero.patch

