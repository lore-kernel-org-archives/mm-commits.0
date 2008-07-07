From: akpm@linux-foundation.org
Subject: - asic3-gpiolib-support-mfd-asic3-should-depend-on-gpiolib.patch removed from -mm tree
Date: Sun, 06 Jul 2008 20:06:03 -0700
Message-ID: <200807070306.m673634o004872@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753483AbYGGDGF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Jul 2008 23:06:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sameo@openedhand.com, mm-commits@vger.kernel.org


The patch titled
     mfd: asic3 should depend on gpiolib
has been removed from the -mm tree.  Its filename was
     asic3-gpiolib-support-mfd-asic3-should-depend-on-gpiolib.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mfd: asic3 should depend on gpiolib
From: Samuel Ortiz <sameo@openedhand.com>

Now that asic3 implements the gpiolib API, it should depend on it at
build time.

Signed-off-by: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mfd/Kconfig~asic3-gpiolib-support-mfd-asic3-should-depend-on-gpiolib drivers/mfd/Kconfig
--- a/drivers/mfd/Kconfig~asic3-gpiolib-support-mfd-asic3-should-depend-on-gpiolib
+++ a/drivers/mfd/Kconfig
@@ -21,7 +21,7 @@ config MFD_SM501
 
 config MFD_ASIC3
 	bool "Support for Compaq ASIC3"
-	depends on GENERIC_HARDIRQS && ARM
+	depends on GENERIC_HARDIRQS && HAVE_GPIO_LIB && ARM
 	 ---help---
 	  This driver supports the ASIC3 multifunction chip found on many
 	  PDAs (mainly iPAQ and HTC based ones)
_

Patches currently in -mm which might be from sameo@openedhand.com are

linux-next.patch
asic3-platform_get_irq-may-return-signed-unnoticed.patch
gpiolib-allow-user-selection.patch

