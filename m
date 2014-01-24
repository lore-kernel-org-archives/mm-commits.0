From: akpm@linux-foundation.org
Subject: [merged] backlight-lp855x-remove-unnecessary-parentheses.patch
 removed from -mm tree
Date: Fri, 24 Jan 2014 11:01:27 -0800
Message-ID: <52e2b887./muchqsjmj84r+LK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbaAXTB1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:01:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] backlight-lp855x-remove-unnecessary-parentheses.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:01:27 -0800


The patch titled
     Subject: backlight: lp855x: remove unnecessary parentheses
has been removed from the -mm tree.  Its filename was
     backlight-lp855x-remove-unnecessary-parentheses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: lp855x: remove unnecessary parentheses

Remove unnecessary parentheses in order to fix the following checkpatch
error.

  ERROR: return is not a function, parentheses are not required

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lp855x_bl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/lp855x_bl.c~backlight-lp855x-remove-unnecessary-parentheses drivers/video/backlight/lp855x_bl.c
--- a/drivers/video/backlight/lp855x_bl.c~backlight-lp855x-remove-unnecessary-parentheses
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -125,7 +125,7 @@ static bool lp855x_is_valid_rom_area(str
 		return false;
 	}
 
-	return (addr >= start && addr <= end);
+	return addr >= start && addr <= end;
 }
 
 static int lp8557_bl_off(struct lp855x *lp)
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
drivers-video-backlight-backlightc-remove-backlight-sysfs-uevent.patch
linux-next.patch
backlight-lcd-call-put_device-if-device_register-fails.patch

