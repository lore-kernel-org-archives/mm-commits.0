From: akpm@linux-foundation.org
Subject: [folded] backlight-ams369fg06-fix-section-mismatch-warning.patch removed from -mm tree
Date: Mon, 25 Jul 2011 16:55:10 -0700
Message-ID: <201107252355.p6PNtAFK006149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751960Ab1GYX4A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jul 2011 19:56:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, anish198519851985@gmail.com, inki.dae@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     backlight: ams369fg06: fix section mismatch warning
has been removed from the -mm tree.  Its filename was
     backlight-ams369fg06-fix-section-mismatch-warning.patch

This patch was dropped because it was folded into backlight-add-ams369fg06-amoled-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: backlight: ams369fg06: fix section mismatch warning
From: Jingoo Han <jg1.han@samsung.com>

Fix section mismatch warning by adding the correct annotation __devinit
to the driver's probe function.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: anish singh <anish198519851985@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ams369fg06.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/ams369fg06.c~backlight-ams369fg06-fix-section-mismatch-warning drivers/video/backlight/ams369fg06.c
--- a/drivers/video/backlight/ams369fg06.c~backlight-ams369fg06-fix-section-mismatch-warning
+++ a/drivers/video/backlight/ams369fg06.c
@@ -473,7 +473,7 @@ static const struct backlight_ops ams369
 	.update_status = ams369fg06_set_brightness,
 };
 
-static int __init ams369fg06_probe(struct spi_device *spi)
+static int __devinit ams369fg06_probe(struct spi_device *spi)
 {
 	int ret = 0;
 	struct ams369fg06 *lcd = NULL;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

backlight-add-ams369fg06-amoled-driver.patch
backlight-ams369fg06-staticize-ams369fg06_shutdown.patch
backlight-set-backlight-type-and-max_brightness-before-backlights-are-registered.patch

