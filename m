From: akpm@linux-foundation.org
Subject: + zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch added to -mm tree
Date: Mon, 04 May 2015 15:56:57 -0700
Message-ID: <5547f939.IvIJGi8X1KxveYbf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41970 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbbEDW46 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2015 18:56:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: cosmetic ZRAM_ATTR_RO code formatting tweak
has been added to the -mm tree.  Its filename is
     zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch

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

revert-zram-move-compact_store-to-sysfs-functions-area.patch
zram-add-compact-sysfs-entry-to-documentation.patch
zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch
zram-use-idr-instead-of-zram_devices-array.patch
zram-reorganize-code-layout.patch
zram-remove-max_num_devices-limitation.patch
zram-report-every-added-and-removed-device.patch
zram-trivial-correct-flag-operations-comment.patch
zram-return-zram-device_id-from-zram_add.patch
zram-close-race-by-open-overriding.patch
zram-add-dynamic-device-add-remove-functionality.patch

