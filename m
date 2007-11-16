From: akpm@linux-foundation.org
Subject: + arm-remove-config-variable-debug_s3c_port.patch added to -mm tree
Date: Thu, 15 Nov 2007 19:10:24 -0800
Message-ID: <200711160310.lAG3AOuh029447@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50846 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757546AbXKPDK1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 22:10:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: olsajiri@gmail.com


The patch titled
     arm: remove config variable DEBUG_S3C_PORT
has been added to the -mm tree.  Its filename is
     arm-remove-config-variable-debug_s3c_port.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: arm: remove config variable DEBUG_S3C_PORT
From: Jiri Olsa <olsajiri@gmail.com>

Remove config variable DEBUG_S3C_PORT, since it is not used.

Signed-off-by: Jiri Olsa <olsajiri@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig.debug             |    8 --------
 arch/arm/configs/s3c2410_defconfig |    1 -
 2 files changed, 9 deletions(-)

diff -puN arch/arm/configs/s3c2410_defconfig~arm-remove-config-variable-debug_s3c_port arch/arm/configs/s3c2410_defconfig
--- a/arch/arm/configs/s3c2410_defconfig~arm-remove-config-variable-debug_s3c_port
+++ a/arch/arm/configs/s3c2410_defconfig
@@ -1392,7 +1392,6 @@ CONFIG_DEBUG_USER=y
 # CONFIG_DEBUG_ERRORS is not set
 CONFIG_DEBUG_LL=y
 # CONFIG_DEBUG_ICEDCC is not set
-CONFIG_DEBUG_S3C_PORT=y
 CONFIG_DEBUG_S3C_UART=0
 
 #
diff -puN arch/arm/Kconfig.debug~arm-remove-config-variable-debug_s3c_port arch/arm/Kconfig.debug
--- a/arch/arm/Kconfig.debug~arm-remove-config-variable-debug_s3c_port
+++ a/arch/arm/Kconfig.debug
@@ -82,14 +82,6 @@ config DEBUG_CLPS711X_UART2
 	  output to the second serial port on these devices.  Saying N will
 	  cause the debug messages to appear on the first serial port.
 
-config DEBUG_S3C_PORT
-	depends on DEBUG_LL && PLAT_S3C
-	bool "Kernel low-level debugging messages via S3C UART"
-	help
-	  Say Y here if you want debug print routines to go to one of the
-	  S3C internal UARTs. The chosen UART must have been configured
-	  before it is used.
-
 config DEBUG_S3C_UART
 	depends on PLAT_S3C
 	int "S3C UART to use for low-level debug"
_

Patches currently in -mm which might be from olsajiri@gmail.com are

origin.patch
git-alsa.patch
arm-remove-dead-config-symbols-from-arm-code.patch
arm-remove-config-variable-debug_s3c_port.patch
m32r-remove-dead-config-symbols-from-m32r-code.patch
mips-remove-dead-config-symbols-from-mips-code.patch
drivers-serial-s3c2410c-remove-dead-config-symbols.patch
frv-remove-dead-config-symbol-from-frv-code.patch
m68knomu-remove-dead-config-symbols-from-m68knomu-code.patch
m68knommu-removing-config-variable-dumptoflash.patch
fs-remove-dead-config-config_has_compat_epoll_event-symbol.patch
