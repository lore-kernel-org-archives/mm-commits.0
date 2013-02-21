From: akpm@linux-foundation.org
Subject: [folded-merged] fb-backlight-add-the-himax-hx-8357b-lcd-controller-remove-trailing-period.patch removed from -mm tree
Date: Thu, 21 Feb 2013 15:22:04 -0800
Message-ID: <20130221232204.EC8115A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:64982 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab3BUXWG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 18:22:06 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so10843yen.3
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 15:22:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maxime.ripard@free-electrons.com, FlorianSchandinat@gmx.de, jg1.han@samsung.com, joe@perches.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: fb: hx8357: Remove trailing period
has been removed from the -mm tree.  Its filename was
     fb-backlight-add-the-himax-hx-8357b-lcd-controller-remove-trailing-period.patch

This patch was dropped because it was folded into fb-backlight-add-the-himax-hx-8357b-lcd-controller.patch

------------------------------------------------------
From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: fb: hx8357: Remove trailing period

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/hx8357.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/hx8357.c~fb-backlight-add-the-himax-hx-8357b-lcd-controller-remove-trailing-period drivers/video/backlight/hx8357.c
--- a/drivers/video/backlight/hx8357.c~fb-backlight-add-the-himax-hx-8357b-lcd-controller-remove-trailing-period
+++ a/drivers/video/backlight/hx8357.c
@@ -120,7 +120,7 @@ static int hx8357_spi_write_then_read(st
 
 	ret = spi_sync(lcd->spi, &msg);
 	if (ret < 0)
-		dev_err(&lcdev->dev, "Couldn't send SPI data.\n");
+		dev_err(&lcdev->dev, "Couldn't send SPI data\n");
 
 	if (txlen)
 		kfree(local_txbuf);
_

Patches currently in -mm which might be from maxime.ripard@free-electrons.com are

origin.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller-use-static-arrays-for-lcd-configuration.patch

