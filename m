From: akpm@linux-foundation.org
Subject: [merged] zram-remove-unused-sector_size-define.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:06:49 -0700
Message-ID: <53e3dc59.fh38DE3VhGus+CK4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:47300 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbaHGUGu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:06:50 -0400
Received: by mail-vc0-f202.google.com with SMTP id hq11so607019vcb.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:06:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, weijie.yang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: remove unused SECTOR_SIZE define
has been removed from the -mm tree.  Its filename was
     zram-remove-unused-sector_size-define.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: remove unused SECTOR_SIZE define

Drop SECTOR_SIZE define, because it's not used.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Weijie Yang <weijie.yang@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/block/zram/zram_drv.h~zram-remove-unused-sector_size-define drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-remove-unused-sector_size-define
+++ a/drivers/block/zram/zram_drv.h
@@ -43,7 +43,6 @@ static const size_t max_zpage_size = PAG
 /*-- End of configurable params */
 
 #define SECTOR_SHIFT		9
-#define SECTOR_SIZE		(1 << SECTOR_SHIFT)
 #define SECTORS_PER_PAGE_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
 #define SECTORS_PER_PAGE	(1 << SECTORS_PER_PAGE_SHIFT)
 #define ZRAM_LOGICAL_BLOCK_SHIFT 12
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch

