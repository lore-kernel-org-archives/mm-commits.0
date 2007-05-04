From: akpm@linux-foundation.org
Subject: + rename-tanbac-tb0219-config.patch added to -mm tree
Date: Thu, 03 May 2007 20:29:41 -0700
Message-ID: <200705040329.l443Tfht028099@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767626AbXEDDaH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 23:30:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yoichi_yuasa@tripeaks.co.jp, ralf@linux-mips.org


The patch titled
     rename TANBAC TB0219 config
has been added to the -mm tree.  Its filename is
     rename-tanbac-tb0219-config.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rename TANBAC TB0219 config
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>

Rename config for TANBAC TB0219 GPIO support to something more appropriate.

Signed-off-by: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/Kconfig  |    4 ++--
 drivers/char/Makefile |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/char/Kconfig~rename-tanbac-tb0219-config drivers/char/Kconfig
--- a/drivers/char/Kconfig~rename-tanbac-tb0219-config
+++ a/drivers/char/Kconfig
@@ -915,8 +915,8 @@ config SONYPI
 	  To compile this driver as a module, choose M here: the
 	  module will be called sonypi.
 
-config TANBAC_TB0219
-	tristate "TANBAC TB0219 base board support"
+config GPIO_TB0219
+	tristate "TANBAC TB0219 GPIO support"
 	depends on TANBAC_TB022X
 	select GPIO_VR41XX
 
diff -puN drivers/char/Makefile~rename-tanbac-tb0219-config drivers/char/Makefile
--- a/drivers/char/Makefile~rename-tanbac-tb0219-config
+++ a/drivers/char/Makefile
@@ -92,7 +92,7 @@ obj-$(CONFIG_PC8736x_GPIO)	+= pc8736x_gp
 obj-$(CONFIG_NSC_GPIO)		+= nsc_gpio.o
 obj-$(CONFIG_CS5535_GPIO)	+= cs5535_gpio.o
 obj-$(CONFIG_GPIO_VR41XX)	+= vr41xx_giu.o
-obj-$(CONFIG_TANBAC_TB0219)	+= tb0219.o
+obj-$(CONFIG_GPIO_TB0219)	+= tb0219.o
 obj-$(CONFIG_TELCLOCK)		+= tlclk.o
 
 obj-$(CONFIG_WATCHDOG)		+= watchdog/
_

Patches currently in -mm which might be from yoichi_yuasa@tripeaks.co.jp are

origin.patch
git-input.patch
git-mips.patch
rename-tanbac-tb0219-config.patch
rtc-update-vr41xx-alarm-handling.patch
