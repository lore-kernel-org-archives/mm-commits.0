From: akpm@linux-foundation.org
Subject: [merged] zram-drop-not-used-table-count-member.patch removed from -mm tree
Date: Tue, 08 Apr 2014 14:03:57 -0700
Message-ID: <5344643d.lV+Jto51RVq/hTj1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56669 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757684AbaDHVD6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:03:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, sergey.senozhatsky@gmail.com

Subject: [merged] zram-drop-not-used-table-count-member.patch removed from -mm tree
To: sergey.senozhatsky@gmail.com,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:03:57 -0700


The patch titled
     Subject: zram: drop not used table `count' member
has been removed from the -mm tree.  Its filename was
     zram-drop-not-used-table-count-member.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: drop not used table `count' member

struct table `count' member is not used.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/block/zram/zram_drv.h~zram-drop-not-used-table-count-member drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-drop-not-used-table-count-member
+++ a/drivers/block/zram/zram_drv.h
@@ -64,7 +64,6 @@ enum zram_pageflags {
 struct table {
 	unsigned long handle;
 	u16 size;	/* object size (excluding header) */
-	u8 count;	/* object ref count (not yet used) */
 	u8 flags;
 } __aligned(4);
 
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch

