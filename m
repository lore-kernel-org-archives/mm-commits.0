From: akpm@linux-foundation.org
Subject: + zram-remove-unused-sector_size-define.patch added to -mm tree
Date: Tue, 24 Jun 2014 13:29:38 -0700
Message-ID: <53a9dfb2.+KlvBEkp7/LaUhgP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbaFXU3j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 16:29:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, weijie.yang@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: remove unused SECTOR_SIZE define
has been added to the -mm tree.  Its filename is
     zram-remove-unused-sector_size-define.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-remove-unused-sector_size-define.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-remove-unused-sector_size-define.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

zram-rename-struct-table-to-zram_table_entry.patch
zram-remove-unused-sector_size-define.patch
mm-zbud-zbud_alloc-minor-param-change.patch
mm-zbud-change-zbud_alloc-size-type-to-size_t.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc.patch
mm-zpool-zbud-zsmalloc-implement-zpool.patch
mm-zpool-update-zswap-to-use-zpool.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used.patch

