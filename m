From: akpm@linux-foundation.org
Subject: [merged] backlight-88pm860x_bl-fix-checkpatch-warning.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:03:53 -0800
Message-ID: <20121218200353.A423D82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:64282 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2LRUDy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:03:54 -0500
Received: by mail-ye0-f202.google.com with SMTP id l7so125245yen.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:03:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: 88pm860x_bl: fix checkpatch warning
has been removed from the -mm tree.  Its filename was
     backlight-88pm860x_bl-fix-checkpatch-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: 88pm860x_bl: fix checkpatch warning

This patch fixes the checkpatch warning as below:

WARNING: quoted string split across lines

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/88pm860x_bl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/88pm860x_bl.c~backlight-88pm860x_bl-fix-checkpatch-warning drivers/video/backlight/88pm860x_bl.c
--- a/drivers/video/backlight/88pm860x_bl.c~backlight-88pm860x_bl-fix-checkpatch-warning
+++ a/drivers/video/backlight/88pm860x_bl.c
@@ -117,8 +117,8 @@ static int pm860x_backlight_set(struct b
 	data->current_brightness = value;
 	return 0;
 out:
-	dev_dbg(chip->dev, "set brightness %d failure with return "
-		"value:%d\n", value, ret);
+	dev_dbg(chip->dev, "set brightness %d failure with return value: %d\n",
+		value, ret);
 	return ret;
 }
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-locomolcd-fix-checkpatch-error-and-warning.patch

