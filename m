From: akpm@linux-foundation.org
Subject: + block-fix-kernel-doc-format-for-blkdev_issue_zeroout.patch added to -mm tree
Date: Mon, 28 Feb 2011 15:08:10 -0800
Message-ID: <201102282308.p1SN8AK4002909@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753025Ab1B1XI3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Feb 2011 18:08:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@decadent.org.uk, axboe@kernel.dk


The patch titled
     block: fix kernel-doc format for blkdev_issue_zeroout
has been added to the -mm tree.  Its filename is
     block-fix-kernel-doc-format-for-blkdev_issue_zeroout.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block: fix kernel-doc format for blkdev_issue_zeroout
From: Ben Hutchings <ben@decadent.org.uk>

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN block/blk-lib.c~block-fix-kernel-doc-format-for-blkdev_issue_zeroout block/blk-lib.c
--- a/block/blk-lib.c~block-fix-kernel-doc-format-for-blkdev_issue_zeroout
+++ a/block/blk-lib.c
@@ -132,7 +132,7 @@ static void bio_batch_end_io(struct bio 
 }
 
 /**
- * blkdev_issue_zeroout generate number of zero filed write bios
+ * blkdev_issue_zeroout - generate number of zero filed write bios
  * @bdev:	blockdev to issue
  * @sector:	start sector
  * @nr_sects:	number of sectors to write
_

Patches currently in -mm which might be from ben@decadent.org.uk are

linux-next.patch
block-fix-kernel-doc-format-for-blkdev_issue_zeroout.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch

