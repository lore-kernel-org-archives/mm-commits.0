From: akpm@linux-foundation.org
Subject: [merged] blackfin-serial-driver-update-path-to-gpio-header.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:10:09 -0700
Message-ID: <200904071910.n37JA9cm012707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750999AbZDGTOi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:14:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk, cooloney@kernel.org, mm-commits@vger.kernel.org


The patch titled
     blackfin serial driver: update path to gpio header
has been removed from the -mm tree.  Its filename was
     blackfin-serial-driver-update-path-to-gpio-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: blackfin serial driver: update path to gpio header
From: Mike Frysinger <vapier.adi@gmail.com>

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/Kconfig |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/serial/Kconfig~blackfin-serial-driver-update-path-to-gpio-header drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~blackfin-serial-driver-update-path-to-gpio-header
+++ a/drivers/serial/Kconfig
@@ -731,7 +731,7 @@ config UART0_CTS_PIN
 	default 23
 	help
 	  The default pin is GPIO_GP7.
-	  Refer to ./include/asm-blackfin/gpio.h to see the GPIO map.
+	  Refer to arch/blackfin/mach-*/include/mach/gpio.h to see the GPIO map.
 
 config UART0_RTS_PIN
 	int "UART0 RTS pin"
@@ -739,7 +739,7 @@ config UART0_RTS_PIN
 	default 22
 	help
 	  The default pin is GPIO_GP6.
-	  Refer to ./include/asm-blackfin/gpio.h to see the GPIO map.
+	  Refer to arch/blackfin/mach-*/include/mach/gpio.h to see the GPIO map.
 
 config SERIAL_BFIN_UART1
 	bool "Enable UART1"
@@ -759,14 +759,14 @@ config UART1_CTS_PIN
 	depends on BFIN_UART1_CTSRTS && !BF548
 	default -1
 	help
-	  Refer to ./include/asm-blackfin/gpio.h to see the GPIO map.
+	  Refer to arch/blackfin/mach-*/include/mach/gpio.h to see the GPIO map.
 
 config UART1_RTS_PIN
 	int "UART1 RTS pin"
 	depends on BFIN_UART1_CTSRTS && !BF548
 	default -1
 	help
-	  Refer to ./include/asm-blackfin/gpio.h to see the GPIO map.
+	  Refer to arch/blackfin/mach-*/include/mach/gpio.h to see the GPIO map.
 
 config SERIAL_BFIN_UART2
 	bool "Enable UART2"
@@ -786,14 +786,14 @@ config UART2_CTS_PIN
 	depends on BFIN_UART2_CTSRTS && !BF548
 	default -1
 	help
-	  Refer to ./include/asm-blackfin/gpio.h to see the GPIO map.
+	  Refer to arch/blackfin/mach-*/include/mach/gpio.h to see the GPIO map.
 
 config UART2_RTS_PIN
 	int "UART2 RTS pin"
 	depends on BFIN_UART2_CTSRTS && !BF548
 	default -1
 	help
-	  Refer to ./include/asm-blackfin/gpio.h to see the GPIO map.
+	  Refer to arch/blackfin/mach-*/include/mach/gpio.h to see the GPIO map.
 
 config SERIAL_BFIN_UART3
 	bool "Enable UART3"
@@ -813,14 +813,14 @@ config UART3_CTS_PIN
 	depends on BFIN_UART3_CTSRTS && !BF548
 	default -1
 	help
-	  Refer to ./include/asm-blackfin/gpio.h to see the GPIO map.
+	  Refer to arch/blackfin/mach-*/include/mach/gpio.h to see the GPIO map.
 
 config UART3_RTS_PIN
 	int "UART3 RTS pin"
 	depends on BFIN_UART3_CTSRTS && !BF548
 	default -1
 	help
-	  Refer to ./include/asm-blackfin/gpio.h to see the GPIO map.
+	  Refer to arch/blackfin/mach-*/include/mach/gpio.h to see the GPIO map.
 
 config SERIAL_IMX
 	bool "IMX serial port support"
_

Patches currently in -mm which might be from vapier.adi@gmail.com are

origin.patch
linux-next.patch

