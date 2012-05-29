From: akpm@linux-foundation.org
Subject: [folded] backlight-add-lm3533-backlight-driver-v4.patch removed from -mm tree
Date: Tue, 29 May 2012 14:49:58 -0700
Message-ID: <20120529214958.7D28EA037F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:42354 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab2E2Vt7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 May 2012 17:49:59 -0400
Received: by vcbfl13 with SMTP id fl13so387789vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 29 May 2012 14:49:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhovold@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight-add-lm3533-backlight-driver-v4
has been removed from the -mm tree.  Its filename was
     backlight-add-lm3533-backlight-driver-v4.patch

This patch was dropped because it was folded into backlight-add-lm3533-backlight-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johan Hovold <jhovold@gmail.com>
Subject: backlight-add-lm3533-backlight-driver-v4

 - fix sysfs-ABI-documentation typo

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-class-backlight-driver-lm3533 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/ABI/testing/sysfs-class-backlight-driver-lm3533~backlight-add-lm3533-backlight-driver-v4 Documentation/ABI/testing/sysfs-class-backlight-driver-lm3533
--- a/Documentation/ABI/testing/sysfs-class-backlight-driver-lm3533~backlight-add-lm3533-backlight-driver-v4
+++ a/Documentation/ABI/testing/sysfs-class-backlight-driver-lm3533
@@ -3,7 +3,7 @@ Date:		April 2012
 KernelVersion:	3.5
 Contact:	Johan Hovold <jhovold@gmail.com>
 Description:
-		Set the ALS-control mode (0,..2), where
+		Set the ALS-control mode (0..2), where
 
 		0 - disabled
 		1 - ALS-mapper 1 (backlight 0)
_

Patches currently in -mm which might be from jhovold@gmail.com are

origin.patch
backlight-add-lm3533-backlight-driver.patch
backlight-add-lm3533-backlight-driver-replace-als-attribute-with-als_channel-and-als_en.patch
leds-add-lm3533-led-driver.patch
leds-add-lm3533-led-driver-fix.patch
leds-add-lm3533-led-driver-replace-als-attribute-with-als_channel-and-als_en.patch

