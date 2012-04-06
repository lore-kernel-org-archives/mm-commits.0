From: akpm@linux-foundation.org
Subject: + rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc.patch added to -mm tree
Date: Fri, 06 Apr 2012 14:55:59 -0700
Message-ID: <20120406215559.EACA6A0395@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:54526 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab2DFV4A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Apr 2012 17:56:00 -0400
Received: by yenq2 with SMTP id q2so314377yen.1
        for <mm-commits@vger.kernel.org>; Fri, 06 Apr 2012 14:56:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: festevam@gmail.com, a.zummo@towertech.it, fabio.estevam@freescale.com, w.sang@pengutronix.de


The patch titled
     Subject: rtc: rename CONFIG_RTC_MXC to CONFIG_RTC_DRV_MXC
has been added to the -mm tree.  Its filename is
     rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabio Estevam <festevam@gmail.com>
Subject: rtc: rename CONFIG_RTC_MXC to CONFIG_RTC_DRV_MXC

In order to keep consistency with other rtc drivers,rename CONFIG_RTC_MXC
to CONFIG_RTC_DRV_MXC.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/configs/imx_v4_v5_defconfig |    2 +-
 drivers/rtc/Kconfig                  |    2 +-
 drivers/rtc/Makefile                 |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/arm/configs/imx_v4_v5_defconfig~rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc arch/arm/configs/imx_v4_v5_defconfig
--- a/arch/arm/configs/imx_v4_v5_defconfig~rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc
+++ a/arch/arm/configs/imx_v4_v5_defconfig
@@ -169,7 +169,7 @@ CONFIG_LEDS_TRIGGER_DEFAULT_ON=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_PCF8563=y
 CONFIG_RTC_DRV_IMXDI=y
-CONFIG_RTC_MXC=y
+CONFIG_RTC_DRV_MXC=y
 CONFIG_DMADEVICES=y
 CONFIG_IMX_SDMA=y
 CONFIG_IMX_DMA=y
diff -puN drivers/rtc/Kconfig~rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc
+++ a/drivers/rtc/Kconfig
@@ -1076,7 +1076,7 @@ config RTC_DRV_LOONGSON1
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-ls1x.
 
-config RTC_MXC
+config RTC_DRV_MXC
 	tristate "Freescale MXC Real Time Clock"
 	depends on ARCH_MXC
 	depends on RTC_CLASS
diff -puN drivers/rtc/Makefile~rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc drivers/rtc/Makefile
--- a/drivers/rtc/Makefile~rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc
+++ a/drivers/rtc/Makefile
@@ -61,7 +61,7 @@ obj-$(CONFIG_RTC_DRV_M41T94)	+= rtc-m41t
 obj-$(CONFIG_RTC_DRV_M48T35)	+= rtc-m48t35.o
 obj-$(CONFIG_RTC_DRV_M48T59)	+= rtc-m48t59.o
 obj-$(CONFIG_RTC_DRV_M48T86)	+= rtc-m48t86.o
-obj-$(CONFIG_RTC_MXC)		+= rtc-mxc.o
+obj-$(CONFIG_RTC_DRV_MXC)	+= rtc-mxc.o
 obj-$(CONFIG_RTC_DRV_MAX6900)	+= rtc-max6900.o
 obj-$(CONFIG_RTC_DRV_MAX8925)	+= rtc-max8925.o
 obj-$(CONFIG_RTC_DRV_MAX8998)	+= rtc-max8998.o
_
Subject: Subject: rtc: rename CONFIG_RTC_MXC to CONFIG_RTC_DRV_MXC

Patches currently in -mm which might be from festevam@gmail.com are

origin.patch
linux-next.patch
rtc-kconfig-place-rtc_drv_imxdi-and-rtc_mxc-under-on-cpu-rtc-drivers.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch

