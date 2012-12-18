From: akpm@linux-foundation.org
Subject: [merged] backlight-88pm860x_bl-remove-an-unnecessary-line-continuation.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:05:39 -0800
Message-ID: <20121218200539.9E15E82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:46685 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab2LRUFk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:05:40 -0500
Received: by mail-ye0-f202.google.com with SMTP id l7so125641yen.3
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:05:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: 88pm860x_bl: remove an unnecessary line continuation
has been removed from the -mm tree.  Its filename was
     backlight-88pm860x_bl-remove-an-unnecessary-line-continuation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: 88pm860x_bl: remove an unnecessary line continuation

Remove an unnecessary line continuation in pm860x_backlight_probe(). 
Also, a checkpatch warning is fixed as below:

WARNING: Avoid unnecessary line continuations

[akpm@linux-foundation.org: remove newline]
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/88pm860x_bl.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/video/backlight/88pm860x_bl.c~backlight-88pm860x_bl-remove-an-unnecessary-line-continuation drivers/video/backlight/88pm860x_bl.c
--- a/drivers/video/backlight/88pm860x_bl.c~backlight-88pm860x_bl-remove-an-unnecessary-line-continuation
+++ a/drivers/video/backlight/88pm860x_bl.c
@@ -228,8 +228,7 @@ static int pm860x_backlight_probe(struct
 	sprintf(name, "backlight-%d", pdev->id);
 	data->port = pdev->id;
 	data->chip = chip;
-	data->i2c = (chip->id == CHIP_PM8606) ? chip->client	\
-			: chip->companion;
+	data->i2c = (chip->id == CHIP_PM8606) ? chip->client : chip->companion;
 	data->current_brightness = MAX_BRIGHTNESS;
 	if (pm860x_backlight_dt_init(pdev, data, name)) {
 		if (pdata) {
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch

