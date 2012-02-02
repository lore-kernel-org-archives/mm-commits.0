From: akpm@linux-foundation.org
Subject: + drivers-leds-add-driver-for-pca9663-i2c-chip-fix-2.patch added to -mm tree
Date: Thu, 02 Feb 2012 15:24:33 -0800
Message-ID: <20120202232434.39E45A03A7@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:62000 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916Ab2BBXYf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Feb 2012 18:24:35 -0500
Received: by yenl2 with SMTP id l2so330456yen.1
        for <mm-commits@vger.kernel.org>; Thu, 02 Feb 2012 15:24:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pmeerw@pmeerw.net


The patch titled
     Subject: drivers-leds-add-driver-for-pca9663-i2c-chip-fix-2
has been added to the -mm tree.  Its filename is
     drivers-leds-add-driver-for-pca9663-i2c-chip-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -234,12 +234,12 @@ config LEDS_PCA955X
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
Subject: Subject: drivers-leds-add-driver-for-pca9663-i2c-chip-fix-2

Patches currently in -mm which might be from pmeerw@pmeerw.net are

drivers-leds-add-driver-for-pca9663-i2c-chip-fix-2.patch

