From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-adp8860_blc-remove-a-redundant-assignment-for-max_brightness.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:52:21 -0700
Message-ID: <201107260751.p6Q7pOE0002944@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386Ab1GZHvx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:51:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     drivers/video/backlight/adp8860_bl.c: remove a redundant assignment for max_brightness
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-adp8860_blc-remove-a-redundant-assignment-for-max_brightness.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/video/backlight/adp8860_bl.c: remove a redundant assignment for max_brightness
From: Axel Lin <axel.lin@gmail.com>

We have set props.max_brightness before registering backlight device.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/adp8860_bl.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/video/backlight/adp8860_bl.c~drivers-video-backlight-adp8860_blc-remove-a-redundant-assignment-for-max_brightness drivers/video/backlight/adp8860_bl.c
--- a/drivers/video/backlight/adp8860_bl.c~drivers-video-backlight-adp8860_blc-remove-a-redundant-assignment-for-max_brightness
+++ a/drivers/video/backlight/adp8860_bl.c
@@ -722,8 +722,7 @@ static int __devinit adp8860_probe(struc
 		goto out2;
 	}
 
-	bl->props.max_brightness =
-		bl->props.brightness = ADP8860_MAX_BRIGHTNESS;
+	bl->props.brightness = ADP8860_MAX_BRIGHTNESS;
 
 	data->bl = bl;
 
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
drivers-video-backlight-aat2870_blc-fix-error-checking-for-backlight_device_register.patch
drivers-video-backlight-aat2870_blc-fix-setting-max_current.patch
drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module.patch

