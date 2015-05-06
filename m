From: akpm@linux-foundation.org
Subject: [withdrawn]
 zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch removed from -mm
 tree
Date: Wed, 06 May 2015 12:52:17 -0700
Message-ID: <554a70f1./9Mb7Or85wzYAIGW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbbEFTwR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 May 2015 15:52:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: cosmetic ZRAM_ATTR_RO code formatting tweak
has been removed from the -mm tree.  Its filename was
     zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: cosmetic ZRAM_ATTR_RO code formatting tweak

Fix a misplaced backslash.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/zram/zram_drv.c~zram-cosmetic-zram_attr_ro-code-formatting-tweak drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-cosmetic-zram_attr_ro-code-formatting-tweak
+++ a/drivers/block/zram/zram_drv.c
@@ -49,7 +49,7 @@ static inline void deprecated_attr_warn(
 }
 
 #define ZRAM_ATTR_RO(name)						\
-static ssize_t name##_show(struct device *d,		\
+static ssize_t name##_show(struct device *d,				\
 				struct device_attribute *attr, char *b)	\
 {									\
 	struct zram *zram = dev_to_zram(d);				\
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-use-idr-instead-of-zram_devices-array.patch
zram-reorganize-code-layout.patch
zram-remove-max_num_devices-limitation.patch
zram-report-every-added-and-removed-device.patch
zram-trivial-correct-flag-operations-comment.patch
zram-return-zram-device_id-from-zram_add.patch
zram-close-race-by-open-overriding.patch
zram-add-dynamic-device-add-remove-functionality.patch

