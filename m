From: akpm@linux-foundation.org
Subject: [merged] backlight-lp8788-remove-unnecessary-parentheses.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 11:01:29 -0800
Message-ID: <52e2b889.4u8uue9IUuW7Bdee%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43596 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbaAXTB3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:01:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-lp8788-remove-unnecessary-parentheses.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:01:29 -0800


The patch titled
     Subject: backlight: lp8788: remove unnecessary parentheses
has been removed from the -mm tree.  Its filename was
     backlight-lp8788-remove-unnecessary-parentheses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: lp8788: remove unnecessary parentheses

Remove unnecessary parentheses in order to fix the following checkpatch
error.

  ERROR: return is not a function, parentheses are not required

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lp8788_bl.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/backlight/lp8788_bl.c~backlight-lp8788-remove-unnecessary-parentheses drivers/video/backlight/lp8788_bl.c
--- a/drivers/video/backlight/lp8788_bl.c~backlight-lp8788-remove-unnecessary-parentheses
+++ a/drivers/video/backlight/lp8788_bl.c
@@ -63,13 +63,13 @@ static struct lp8788_bl_config default_b
 
 static inline bool is_brightness_ctrl_by_pwm(enum lp8788_bl_ctrl_mode mode)
 {
-	return (mode == LP8788_BL_COMB_PWM_BASED);
+	return mode == LP8788_BL_COMB_PWM_BASED;
 }
 
 static inline bool is_brightness_ctrl_by_register(enum lp8788_bl_ctrl_mode mode)
 {
-	return (mode == LP8788_BL_REGISTER_ONLY ||
-		mode == LP8788_BL_COMB_REGISTER_BASED);
+	return mode == LP8788_BL_REGISTER_ONLY ||
+		mode == LP8788_BL_COMB_REGISTER_BASED;
 }
 
 static int lp8788_backlight_configure(struct lp8788_bl *bl)
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
linux-next.patch
backlight-lcd-call-put_device-if-device_register-fails.patch

