From: akpm@linux-foundation.org
Subject: [folded] drivers-leds-add-driver-for-pca9663-i2c-chip-fix-2.patch removed from -mm tree
Date: Fri, 23 Mar 2012 14:26:13 -0700
Message-ID: <20120323212614.21959A0395@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:37477 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab2CWV0P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 17:26:15 -0400
Received: by ghbz15 with SMTP id z15so566118ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:26:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmeerw@pmeerw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers-leds-add-driver-for-pca9663-i2c-chip-fix-2
has been removed from the -mm tree.  Its filename was
     drivers-leds-add-driver-for-pca9663-i2c-chip-fix-2.patch

This patch was dropped because it was folded into drivers-leds-add-driver-for-pca9663-i2c-chip.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Peter Meerwald <pmeerw@pmeerw.net>
Subject: drivers-leds-add-driver-for-pca9663-i2c-chip-fix-2



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/leds/Kconfig~drivers-leds-add-driver-for-pca9663-i2c-chip-fix-2 drivers/leds/Kconfig
--- a/drivers/leds/Kconfig~drivers-leds-add-driver-for-pca9663-i2c-chip-fix-2
+++ a/drivers/leds/Kconfig
@@ -227,12 +227,12 @@ config LEDS_PCA955X
 	  LED driver chips accessed via the I2C bus.  Supported
 	  devices include PCA9550, PCA9551, PCA9552, and PCA9553.
 
-config LEDS_PCA9663
-	tristate "LED support for PCA9663 I2C chip"
+config LEDS_PCA9633
+	tristate "LED support for PCA9633 I2C chip"
 	depends on LEDS_CLASS
 	depends on I2C
 	help
-	  This option enables support for LEDs connected to the PCA9663
+	  This option enables support for LEDs connected to the PCA9633
 	  LED driver chip accessed via the I2C bus.
 
 config LEDS_WM831X_STATUS
_

Patches currently in -mm which might be from pmeerw@pmeerw.net are

drivers-leds-add-driver-for-pca9663-i2c-chip.patch

