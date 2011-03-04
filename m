From: akpm@linux-foundation.org
Subject: [merged] block-fix-kernel-doc-format-for-blkdev_issue_zeroout.patch removed from -mm tree
Date: Fri, 04 Mar 2011 15:16:07 -0800
Message-ID: <201103042316.p24NGIE8009476@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45256 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759891Ab1CDXQg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2011 18:16:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@decadent.org.uk, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     block: fix kernel-doc format for blkdev_issue_zeroout
has been removed from the -mm tree.  Its filename was
     block-fix-kernel-doc-format-for-blkdev_issue_zeroout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
fs-inode-fix-kernel-doc-format-for-inode_init_owner.patch

