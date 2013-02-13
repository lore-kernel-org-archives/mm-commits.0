From: akpm@linux-foundation.org
Subject: + fb-backlight-add-the-himax-hx-8357b-lcd-controller-remove-trailing-period.patch added to -mm tree
Date: Wed, 13 Feb 2013 14:49:47 -0800
Message-ID: <20130213224947.8EA0E31C1B0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:52892 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760432Ab3BMWts (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Feb 2013 17:49:48 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so170315yhz.3
        for <mm-commits@vger.kernel.org>; Wed, 13 Feb 2013 14:49:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maxime.ripard@free-electrons.com, FlorianSchandinat@gmx.de, jg1.han@samsung.com, joe@perches.com, rpurdie@rpsys.net


The patch titled
     Subject: fb: hx8357: Remove trailing period
has been added to the -mm tree.  Its filename is
     fb-backlight-add-the-himax-hx-8357b-lcd-controller-remove-trailing-period.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller-change-parameters-of-the-write-function-to-u8.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller-fix-inverted-parameters-for-kcalloc.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller-remove-useless-error-message.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller-remove-trailing-period.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller-use-static-arrays-for-lcd-configuration.patch

