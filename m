From: akpm@linux-foundation.org
Subject: [folded-merged]
 zram-write-incompressible-pages-to-backing-device-fix.patch removed from
 -mm tree
Date: Wed, 06 Sep 2017 15:58:32 -0700
Message-ID: <59b07d98.PEHNyftdCiR8eLfa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45908 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752361AbdIFW6d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 18:58:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xieyisheng1@huawei.com, juno.choi@lge.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: fix typo in comment
has been removed from the -mm tree.  Its filename was
     zram-write-incompressible-pages-to-backing-device-fix.patch

This patch was dropped because it was folded into zram-write-incompressible-pages-to-backing-device.patch

------------------------------------------------------
From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: zram: fix typo in comment

ZRAM_SAME means page consists the same element not the entirely zero page.

Link: http://lkml.kernel.org/r/1502707447-6944-2-git-send-email-xieyisheng1@huawei.com
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Juneho Choi <juno.choi@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/zram/zram_drv.h~zram-write-incompressible-pages-to-backing-device-fix drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-write-incompressible-pages-to-backing-device-fix
+++ a/drivers/block/zram/zram_drv.h
@@ -60,7 +60,7 @@ static const size_t max_zpage_size = PAG
 
 /* Flags for zram pages (table[page_no].value) */
 enum zram_pageflags {
-	/* Page consists entirely of zeros */
+	/* Page consists the same element */
 	ZRAM_SAME = ZRAM_FLAG_SHIFT,
 	ZRAM_ACCESS,	/* page is now accessed */
 	ZRAM_WB,	/* page is stored on backing_device */
_

Patches currently in -mm which might be from xieyisheng1@huawei.com are

zram-write-incompressible-pages-to-backing-device.patch
zram-read-page-from-backing-device-fix.patch

