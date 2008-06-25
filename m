From: akpm@linux-foundation.org
Subject: + asic3-gpiolib-support-mfd-asic3-should-depend-on-gpiolib.patch added to -mm tree
Date: Wed, 25 Jun 2008 14:41:11 -0700
Message-ID: <200806252141.m5PLfBZP028233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752479AbYFYVls (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jun 2008 17:41:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sameo@openedhand.com


The patch titled
     mfd: asic3 should depend on gpiolib
has been added to the -mm tree.  Its filename is
     asic3-gpiolib-support-mfd-asic3-should-depend-on-gpiolib.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -17,7 +17,7 @@ config MFD_SM501
 
 config MFD_ASIC3
 	bool "Support for Compaq ASIC3"
-	depends on GENERIC_HARDIRQS && ARM
+	depends on GENERIC_HARDIRQS && HAVE_GPIO_LIB && ARM
 	 ---help---
 	  This driver supports the ASIC3 multifunction chip found on many
 	  PDAs (mainly iPAQ and HTC based ones)
_

Patches currently in -mm which might be from sameo@openedhand.com are

asic3-platform_get_irq-may-return-signed-unnoticed.patch
asic3-gpiolib-support.patch
asic3-gpiolib-support-mfd-asic3-should-depend-on-gpiolib.patch
asic3-remove-children-platform-data.patch
asic3-new-gpio-configuration-code.patch
asic3-new-gpio-configuration-code-fix-asic3-config-array-initialisation.patch
asic3-use-dev_-macros.patch
asic3-use-uppercase-only-for-macros-and-defines.patch
mfd-move-asic3-probe-functions-into-__init-section.patch

