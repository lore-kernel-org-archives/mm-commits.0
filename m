From: akpm@linux-foundation.org
Subject: - rivafb-fix-i2c-getscl-callback-function.patch removed from -mm tree
Date: Fri, 11 May 2007 22:35:42 -0700
Message-ID: <200705120535.l4C5ZgWo002319@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756398AbXELFf6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 May 2007 01:35:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     rivafb: Fix I2C getscl callback function
has been removed from the -mm tree.  Its filename was
     rivafb-fix-i2c-getscl-callback-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rivafb: Fix I2C getscl callback function
From: Jean Delvare <khali@linux-fr.org>

Fix rivafb's I2C getscl callback function, as was done in nvidiafb recently.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/riva/rivafb-i2c.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/video/riva/rivafb-i2c.c~rivafb-fix-i2c-getscl-callback-function drivers/video/riva/rivafb-i2c.c
--- a/drivers/video/riva/rivafb-i2c.c~rivafb-fix-i2c-getscl-callback-function
+++ a/drivers/video/riva/rivafb-i2c.c
@@ -70,8 +70,6 @@ static int riva_gpio_getscl(void* data)
 	if (VGA_RD08(par->riva.PCIO, 0x3d5) & 0x04)
 		val = 1;
 
-	val = VGA_RD08(par->riva.PCIO, 0x3d5);
-
 	return val;
 }
 
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
git-alsa.patch
git-dvb.patch
i2c-add-driver-for-dallas-ds1682-elapsed-time-recorder.patch
