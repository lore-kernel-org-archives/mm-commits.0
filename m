From: akpm@linux-foundation.org
Subject: + bluetooth-fix-build-warnings-on-defconfigs.patch added to -mm tree
Date: Mon, 11 Apr 2011 16:39:15 -0700
Message-ID: <201104112339.p3BNdFmN011071@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752110Ab1DKXjo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Apr 2011 19:39:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wanlong.gao@gmail.com, grinberg@compulab.co.il, marcel@holtmann.org, plagnioj@jcrosoft.com, u.kleine-koenig@pengutronix.de


The patch titled
     bluetooth: fix build warnings on defconfigs
has been added to the -mm tree.  Its filename is
     bluetooth-fix-build-warnings-on-defconfigs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: bluetooth: fix build warnings on defconfigs
=46rom: Wanlong Gao <wanlong.gao@gmail.com>

Change the BT_L2CAP and BT_SCO defconfigs from 'm' to 'y',
since BT_L2CAP and BT_SCO had changed to bool configs.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
Acked-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Marcel Holtmann <marcel@holtmann.org>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Acked-by: Igor Grinberg <grinberg@compulab.co.il>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/configs/am200epdkit_defconfig     |    4 ++--
 arch/arm/configs/at572d940hfek_defconfig   |    2 +-
 arch/arm/configs/at91rm9200_defconfig      |    4 ++--
 arch/arm/configs/badge4_defconfig          |    2 +-
 arch/arm/configs/cm_x2xx_defconfig         |    4 ++--
 arch/arm/configs/cm_x300_defconfig         |    4 ++--
 arch/arm/configs/colibri_pxa270_defconfig  |    4 ++--
 arch/arm/configs/corgi_defconfig           |    4 ++--
 arch/arm/configs/davinci_all_defconfig     |    2 +-
 arch/arm/configs/em_x270_defconfig         |    4 ++--
 arch/arm/configs/magician_defconfig        |    4 ++--
 arch/arm/configs/mini2440_defconfig        |    4 ++--
 arch/arm/configs/nhk8815_defconfig         |    4 ++--
 arch/arm/configs/ns9xxx_defconfig          |    2 +-
 arch/arm/configs/omap2plus_defconfig       |    4 ++--
 arch/arm/configs/pxa3xx_defconfig          |    2 +-
 arch/arm/configs/s3c2410_defconfig         |    6 +++---
 arch/arm/configs/simpad_defconfig          |    4 ++--
 arch/arm/configs/spitz_defconfig           |    4 ++--
 arch/arm/configs/trizeps4_defconfig        |    4 ++--
 arch/arm/configs/viper_defconfig           |    2 +-
 arch/arm/configs/zeus_defconfig            |    4 ++--
 arch/avr32/configs/atngw100_mrmt_defconfig |    2 +-
 arch/mips/configs/lemote2f_defconfig       |    4 ++--
 arch/mips/configs/mtx1_defconfig           |    4 ++--
 arch/powerpc/configs/c2k_defconfig         |    4 ++--
 arch/powerpc/configs/pmac32_defconfig      |    4 ++--
 arch/powerpc/configs/ppc6xx_defconfig      |    4 ++--
 arch/powerpc/configs/ps3_defconfig         |    4 ++--
 29 files changed, 52 insertions(+), 52 deletions(-)

diff -puN arch/arm/configs/am200epdkit_defconfig~bluetooth-fix-build-wa=
rnings-on-defconfigs arch/arm/configs/am200epdkit_defconfig
--- a/arch/arm/configs/am200epdkit_defconfig~bluetooth-fix-build-warnin=
gs-on-defconfigs
+++ a/arch/arm/configs/am200epdkit_defconfig
@@ -34,8 +34,8 @@ CONFIG_INET=3Dy
 # CONFIG_INET_DIAG is not set
 # CONFIG_IPV6 is not set
 CONFIG_BT=3Dm
-CONFIG_BT_L2CAP=3Dm
-CONFIG_BT_SCO=3Dm
+CONFIG_BT_L2CAP=3Dy
+CONFIG_BT_SCO=3Dy
 CONFIG_BT_RFCOMM=3Dm
 CONFIG_BT_RFCOMM_TTY=3Dy
 CONFIG_BT_BNEP=3Dm
diff -puN arch/arm/configs/at572d940hfek_defconfig~bluetooth-fix-build-=
warnings-on-defconfigs arch/arm/configs/at572d940hfek_defconfig
--- a/arch/arm/configs/at572d940hfek_defconfig~bluetooth-fix-build-warn=
ings-on-defconfigs
+++ a/arch/arm/configs/at572d940hfek_defconfig
@@ -280,7 +280,7 @@ CONFIG_SDIO_UART=3Dm
 CONFIG_MMC_AT91=3Dm
 CONFIG_MMC_SPI=3Dm
 CONFIG_NEW_LEDS=3Dy
-CONFIG_LEDS_CLASS=3Dm
+CONFIG_LEDS_CLASS=3Dy
 CONFIG_LEDS_GPIO=3Dm
 CONFIG_LEDS_TRIGGERS=3Dy
 CONFIG_LEDS_TRIGGER_TIMER=3Dm
diff -puN arch/arm/configs/at91rm9200_defconfig~bluetooth-fix-build-war=
nings-on-defconfigs arch/arm/configs/at91rm9200_defconfig
--- a/arch/arm/configs/at91rm9200_defconfig~bluetooth-fix-build-warning=
s-on-defconfigs
+++ a/arch/arm/configs/at91rm9200_defconfig
@@ -75,8 +75,8 @@ CONFIG_IPV6_TUNNEL=3Dm
 CONFIG_BRIDGE=3Dm
 CONFIG_VLAN_8021Q=3Dm
 CONFIG_BT=3Dm
-CONFIG_BT_L2CAP=3Dm
-CONFIG_BT_SCO=3Dm
+CONFIG_BT_L2CAP=3Dy
+CONFIG_BT_SCO=3Dy
 CONFIG_BT_RFCOMM=3Dm
 CONFIG_BT_RFCOMM_TTY=3Dy
 CONFIG_BT_BNEP=3Dm
diff -puN arch/arm/configs/badge4_defconfig~bluetooth-fix-build-warning=
s-on-defconfigs arch/arm/configs/badge4_defconfig
--- a/arch/arm/configs/badge4_defconfig~bluetooth-fix-build-warnings-on=
-defconfigs
+++ a/arch/arm/configs/badge4_defconfig
@@ -24,7 +24,7 @@ CONFIG_IRCOMM=3Dy
 CONFIG_IRDA_ULTRA=3Dy
 CONFIG_SA1100_FIR=3Dy
 CONFIG_BT=3Dm
-CONFIG_BT_L2CAP=3Dm
+CONFIG_BT_L2CAP=3Dy
 CONFIG_BT_HCIUART=3Dm
 CONFIG_BT_HCIVHCI=3Dm
 # CONFIG_FW_LOADER is not set
diff -puN arch/arm/configs/cm_x2xx_defconfig~bluetooth-fix-build-warnin=
gs-on-defconfigs arch/arm/configs/cm_x2xx_defconfig
--- a/arch/arm/configs/cm_x2xx_defconfig~bluetooth-fix-build-warnings-o=
n-defconfigs
+++ a/arch/arm/configs/cm_x2xx_defconfig
@@ -43,8 +43,8 @@ CONFIG_IP_PNP_BOOTP=3Dy
 # CONFIG_INET_DIAG is not set
 # CONFIG_IPV6 is not set
 CONFIG_BT=3Dm
-CONFIG_BT_L2CAP=3Dm
-CONFIG_BT_SCO=3Dm
+CONFIG_BT_L2CAP=3Dy
+CONFIG_BT_SCO=3Dy
 CONFIG_BT_RFCOMM=3Dm
 CONFIG_BT_BNEP=3Dm
 CONFIG_BT_HIDP=3Dm
diff -puN arch/arm/configs/cm_x300_defconfig~bluetooth-fix-build-warnin=
gs-on-defconfigs arch/arm/configs/cm_x300_defconfig
--- a/arch/arm/configs/cm_x300_defconfig~bluetooth-fix-build-warnings-o=
n-defconfigs
+++ a/arch/arm/configs/cm_x300_defconfig
@@ -40,8 +40,8 @@ CONFIG_IP_PNP_RARP=3Dy
 # CONFIG_INET_DIAG is not set
 # CONFIG_IPV6 is not set
 CONFIG_BT=3Dm
-CONFIG_BT_L2CAP=3Dm
-CONFIG_BT_SCO=3Dm
+CONFIG_BT_L2CAP=3Dy
+CONFIG_BT_SCO=3Dy
 CONFIG_BT_RFCOMM=3Dm
 CONFIG_BT_RFCOMM_TTY=3Dy
 CONFIG_BT_BNEP=3Dm
diff -puN arch/arm/configs/colibri_pxa270_defconfig~bluetooth-fix-build=
-warnings-on-defconfigs arch/arm/configs/colibri_pxa270_defconfig
--- a/arch/arm/configs/colibri_pxa270_defconfig~bluetooth-fix-build-war=
nings-on-defconfigs
+++ a/arch/arm/configs/colibri_pxa270_defconfig
@@ -45,8 +45,8 @@ CONFIG_IRDA_CACHE_LAST_LSAP=3Dy
 CONFIG_IRDA_FAST_RR=3Dy
 CONFIG_IRTTY_SIR=3Dm
 CONFIG_BT=3Dm
-CONFIG_BT_L2CAP=3Dm
-CONFIG_BT_SCO=3Dm
+CONFIG_BT_L2CAP=3Dy
+CONFIG_BT_SCO=3Dy
 CONFIG_BT_RFCOMM=3Dm
 CONFIG_BT_RFCOMM_TTY=3Dy
 CONFIG_BT_BNEP=3Dm
diff -puN arch/arm/configs/corgi_defconfig~bluetooth-fix-build-warnings=
-on-defconfigs arch/arm/configs/corgi_defconfig
--- a/arch/arm/configs/corgi_defconfig~bluetooth-fix-build-warnings-on-=
defconfigs
+++ a/arch/arm/configs/corgi_defconfig
@@ -69,8 +69,8 @@ CONFIG_IRNET=3Dm
 CONFIG_IRCOMM=3Dm
 CONFIG_PXA_FICP=3Dm
 CONFIG_BT=3Dm
-CONFIG_BT_L2CAP=3Dm
-CONFIG_BT_SCO=3Dm
+CONFIG_BT_L2CAP=3Dy
+CONFIG_BT_SCO=3Dy
 CONFIG_BT_RFCOMM=3Dm
 CONFIG_BT_RFCOMM_TTY=3Dy
 CONFIG_BT_BNEP=3Dm
diff -puN arch/arm/configs/davinci_all_defconfig~bluetooth-fix-build-wa=
rnings-on-defconfigs arch/arm/configs/davinci_all_defconfig
--- a/arch/arm/configs/davinci_all_defconfig~bluetooth-fix-build-warnin=
gs-on-defconfigs
+++ a/arch/arm/configs/davinci_all_defconfig
@@ -152,7 +152,7 @@ CONFIG_MMC=3Dm
 # CONFIG_MMC_BLOCK_BOUNCE is not set
 CONFIG_MMC_DAVINCI=3Dm
 CONFIG_NEW_LEDS=3Dy
-CONFIG_LEDS_CLASS=3Dm
+CONFIG_LEDS_CLASS=3Dy
 CONFIG_LEDS_GPIO=3Dm
 CONFIG_LEDS_TRIGGERS=3Dy
 CONFIG_LEDS_TRIGGER_TIMER=3Dm
diff -puN arch/arm/configs/em_x270_defconfig~bluetooth-fix-build-warnin=
gs-on-defconfigs arch/arm/configs/em_x270_defconfig
--- a/arch/arm/configs/em_x270_defconfig~bluetooth-fix-build-warnings-o=
n-defconfigs
+++ a/arch/arm/configs/em_x270_defconfig
@@ -38,8 +38,8 @@ CONFIG_IP_PNP_BOOTP=3Dy
 # CONFIG_INET_DIAG is not set
 # CONFIG_IPV6 is not set
 CONFIG_BT=3Dm
-CONFIG_BT_L2CAP=3Dm
-CONFIG_BT_SCO=3Dm
+CONFIG_BT_L2CAP=3Dy
+CONFIG_BT_SCO=3Dy
 CONFIG_BT_RFCOMM=3Dm
 CONFIG_BT_BNEP=3Dm
 CONFIG_BT_HIDP=3Dm
diff -puN arch/arm/configs/magician_defconfig~bluetooth-fix-build-warni=
ngs-on-defconfigs arch/arm/configs/magician_defconfig
--- a/arch/arm/configs/magician_defconfig~bluetooth-fix-build-warnings-=
on-defconfigs
+++ a/arch/arm/configs/magician_defconfig
@@ -48,8 +48,8 @@ CONFIG_IRDA_DEBUG=3Dy
 CONFIG_IRTTY_SIR=3Dm
 CONFIG_PXA_FICP=3Dm
 CONFIG_BT=3Dm
-CONFIG_BT_L2CAP=3Dm
-CONFIG_BT_SCO=3Dm
+CONFIG_BT_L2CAP=3Dy
+CONFIG_BT_SCO=3Dy
 CONFIG_BT_RFCOMM=3Dm
 CONFIG_BT_RFCOMM_TTY=3Dy
 CONFIG_BT_BNEP=3Dm
diff -puN arch/arm/configs/mini2440_defconfig~bluetooth-fix-build-warni=
ngs-on-defconfigs arch/arm/configs/mini2440_defconfig
--- a/arch/arm/configs/mini2440_defconfig~bluetooth-fix-build-warnings-=
on-defconfigs
+++ a/arch/arm/configs/mini2440_defconfig
@@ -56,8 +56,8 @@ CONFIG_VLAN_8021Q=3Dm
 CONFIG_VLAN_8021Q_GVRP=3Dy
 CONFIG_NET_PKTGEN=3Dm
 CONFIG_BT=3Dm
-CONFIG_BT_L2CAP=3Dm
-CONFIG_BT_SCO=3Dm
+CONFIG_BT_L2CAP=3Dy
+CONFIG_BT_SCO=3Dy
 CONFIG_BT_RFCOMM=3Dm
 CONFIG_BT_RFCOMM_TTY=3Dy
 CONFIG_BT_BNEP=3Dm
diff -puN arch/arm/configs/nhk8815_defconfig~bluetooth-fix-build-warnin=
gs-on-defconfigs arch/arm/configs/nhk8815_defconfig
--- a/arch/arm/configs/nhk8815_defconfig~bluetooth-fix-build-warnings-o=
n-defconfigs
+++ a/arch/arm/configs/nhk8815_defconfig
@@ -38,8 +38,8 @@ CONFIG_IP_MROUTE=3Dy
 # CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_BT=3Dm
-CONFIG_BT_L2CAP=3Dm
-CONFIG_BT_SCO=3Dm
+CONFIG_BT_L2CAP=3Dy
+CONFIG_BT_SCO=3Dy
 CONFIG_BT_RFCOMM=3Dm
 CONFIG_BT_RFCOMM_TTY=3Dy
 CONFIG_BT_BNEP=3Dm
diff -puN arch/arm/configs/ns9xxx_defconfig~bluetooth-fix-build-warning=
s-on-defconfigs arch/arm/configs/ns9xxx_defconfig
--- a/arch/arm/configs/ns9xxx_defconfig~bluetooth-fix-build-warnings-on=
-defconfigs
+++ a/arch/arm/configs/ns9xxx_defconfig
@@ -38,7 +38,7 @@ CONFIG_I2C_GPIO=3Dm
 # CONFIG_VGA_CONSOLE is not set
 # CONFIG_USB_SUPPORT is not set
 CONFIG_NEW_LEDS=3Dy
-CONFIG_LEDS_CLASS=3Dm
+CONFIG_LEDS_CLASS=3Dy
 CONFIG_LEDS_GPIO=3Dm
 CONFIG_LEDS_TRIGGERS=3Dy
 CONFIG_LEDS_TRIGGER_TIMER=3Dm
diff -puN arch/arm/configs/omap2plus_defconfig~bluetooth-fix-build-warn=
ings-on-defconfigs arch/arm/configs/omap2plus_defconfig
--- a/arch/arm/configs/omap2plus_defconfig~bluetooth-fix-build-warnings=
-on-defconfigs
+++ a/arch/arm/configs/omap2plus_defconfig
@@ -89,8 +89,8 @@ CONFIG_IP_PNP_RARP=3Dy
 # CONFIG_IPV6 is not set
 CONFIG_NETFILTER=3Dy
 CONFIG_BT=3Dm
-CONFIG_BT_L2CAP=3Dm
-CONFIG_BT_SCO=3Dm
+CONFIG_BT_L2CAP=3Dy
+CONFIG_BT_SCO=3Dy
 CONFIG_BT_RFCOMM=3Dy
 CONFIG_BT_RFCOMM_TTY=3Dy
 CONFIG_BT_BNEP=3Dm
diff -puN arch/arm/configs/pxa3xx_defconfig~bluetooth-fix-build-warning=
s-on-defconfigs arch/arm/configs/pxa3xx_defconfig
--- a/arch/arm/configs/pxa3xx_defconfig~bluetooth-fix-build-warnings-on=
-defconfigs
+++ a/arch/arm/configs/pxa3xx_defconfig
@@ -99,7 +99,7 @@ CONFIG_LOGO=3Dy
 CONFIG_MMC=3Dy
 CONFIG_MMC_PXA=3Dy
 CONFIG_NEW_LEDS=3Dy
-CONFIG_LEDS_CLASS=3Dm
+CONFIG_LEDS_CLASS=3Dy
 CONFIG_LEDS_GPIO=3Dm
 CONFIG_LEDS_DA903X=3Dm
 CONFIG_LEDS_TRIGGERS=3Dy
diff -puN arch/arm/configs/s3c2410_defconfig~bluetooth-fix-build-warnin=
gs-on-defconfigs arch/arm/configs/s3c2410_defconfig
--- a/arch/arm/configs/s3c2410_defconfig~bluetooth-fix-build-warnings-o=
n-defconfigs
+++ a/arch/arm/configs/s3c2410_defconfig
@@ -177,8 +177,8 @@ CONFIG_IP6_NF_TARGET_REJECT=3Dm
 CONFIG_IP6_NF_MANGLE=3Dm
 CONFIG_IP6_NF_RAW=3Dm
 CONFIG_BT=3Dm
-CONFIG_BT_L2CAP=3Dm
-CONFIG_BT_SCO=3Dm
+CONFIG_BT_L2CAP=3Dy
+CONFIG_BT_SCO=3Dy
 CONFIG_BT_RFCOMM=3Dm
 CONFIG_BT_RFCOMM_TTY=3Dy
 CONFIG_BT_BNEP=3Dm
@@ -387,7 +387,7 @@ CONFIG_MMC_TEST=3Dm
 CONFIG_MMC_SDHCI=3Dm
 CONFIG_MMC_SPI=3Dm
 CONFIG_MMC_S3C=3Dy
-CONFIG_LEDS_CLASS=3Dm
+CONFIG_LEDS_CLASS=3Dy
 CONFIG_LEDS_S3C24XX=3Dm
 CONFIG_LEDS_H1940=3Dm
 CONFIG_LEDS_PCA9532=3Dm
diff -puN arch/arm/configs/simpad_defconfig~bluetooth-fix-build-warning=
s-on-defconfigs arch/arm/configs/simpad_defconfig
--- a/arch/arm/configs/simpad_defconfig~bluetooth-fix-build-warnings-on=
-defconfigs
+++ a/arch/arm/configs/simpad_defconfig
@@ -33,8 +33,8 @@ CONFIG_IRCOMM=3Dm
 CONFIG_IRTTY_SIR=3Dm
 CONFIG_SA1100_FIR=3Dm
 CONFIG_BT=3Dm
-CONFIG_BT_L2CAP=3Dm
-CONFIG_BT_SCO=3Dm
+CONFIG_BT_L2CAP=3Dy
+CONFIG_BT_SCO=3Dy
 CONFIG_BT_RFCOMM=3Dm
 CONFIG_BT_RFCOMM_TTY=3Dy
 CONFIG_BT_BNEP=3Dm
diff -puN arch/arm/configs/spitz_defconfig~bluetooth-fix-build-warnings=
-on-defconfigs arch/arm/configs/spitz_defconfig
--- a/arch/arm/configs/spitz_defconfig~bluetooth-fix-build-warnings-on-=
defconfigs
+++ a/arch/arm/configs/spitz_defconfig
@@ -66,8 +66,8 @@ CONFIG_IRNET=3Dm
 CONFIG_IRCOMM=3Dm
 CONFIG_PXA_FICP=3Dm
 CONFIG_BT=3Dm
-CONFIG_BT_L2CAP=3Dm
-CONFIG_BT_SCO=3Dm
+CONFIG_BT_L2CAP=3Dy
+CONFIG_BT_SCO=3Dy
 CONFIG_BT_RFCOMM=3Dm
 CONFIG_BT_RFCOMM_TTY=3Dy
 CONFIG_BT_BNEP=3Dm
diff -puN arch/arm/configs/trizeps4_defconfig~bluetooth-fix-build-warni=
ngs-on-defconfigs arch/arm/configs/trizeps4_defconfig
--- a/arch/arm/configs/trizeps4_defconfig~bluetooth-fix-build-warnings-=
on-defconfigs
+++ a/arch/arm/configs/trizeps4_defconfig
@@ -49,8 +49,8 @@ CONFIG_IRDA_CACHE_LAST_LSAP=3Dy
 CONFIG_IRDA_FAST_RR=3Dy
 CONFIG_IRTTY_SIR=3Dm
 CONFIG_BT=3Dm
-CONFIG_BT_L2CAP=3Dm
-CONFIG_BT_SCO=3Dm
+CONFIG_BT_L2CAP=3Dy
+CONFIG_BT_SCO=3Dy
 CONFIG_BT_RFCOMM=3Dm
 CONFIG_BT_RFCOMM_TTY=3Dy
 CONFIG_BT_BNEP=3Dm
diff -puN arch/arm/configs/viper_defconfig~bluetooth-fix-build-warnings=
-on-defconfigs arch/arm/configs/viper_defconfig
--- a/arch/arm/configs/viper_defconfig~bluetooth-fix-build-warnings-on-=
defconfigs
+++ a/arch/arm/configs/viper_defconfig
@@ -37,7 +37,7 @@ CONFIG_SYN_COOKIES=3Dy
 # CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_BT=3Dm
-CONFIG_BT_L2CAP=3Dm
+CONFIG_BT_L2CAP=3Dy
 CONFIG_BT_RFCOMM=3Dm
 CONFIG_BT_RFCOMM_TTY=3Dy
 CONFIG_BT_BNEP=3Dm
diff -puN arch/arm/configs/zeus_defconfig~bluetooth-fix-build-warnings-=
on-defconfigs arch/arm/configs/zeus_defconfig
--- a/arch/arm/configs/zeus_defconfig~bluetooth-fix-build-warnings-on-d=
efconfigs
+++ a/arch/arm/configs/zeus_defconfig
@@ -32,7 +32,7 @@ CONFIG_SYN_COOKIES=3Dy
 # CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_BT=3Dm
-CONFIG_BT_L2CAP=3Dm
+CONFIG_BT_L2CAP=3Dy
 CONFIG_BT_RFCOMM=3Dm
 CONFIG_BT_RFCOMM_TTY=3Dy
 CONFIG_BT_BNEP=3Dm
@@ -150,7 +150,7 @@ CONFIG_MMC=3Dy
 # CONFIG_MMC_BLOCK_BOUNCE is not set
 CONFIG_MMC_PXA=3Dy
 CONFIG_NEW_LEDS=3Dy
-CONFIG_LEDS_CLASS=3Dm
+CONFIG_LEDS_CLASS=3Dy
 CONFIG_LEDS_GPIO=3Dm
 CONFIG_LEDS_TRIGGERS=3Dy
 CONFIG_LEDS_TRIGGER_TIMER=3Dm
diff -puN arch/avr32/configs/atngw100_mrmt_defconfig~bluetooth-fix-buil=
d-warnings-on-defconfigs arch/avr32/configs/atngw100_mrmt_defconfig
--- a/arch/avr32/configs/atngw100_mrmt_defconfig~bluetooth-fix-build-wa=
rnings-on-defconfigs
+++ a/arch/avr32/configs/atngw100_mrmt_defconfig
@@ -36,7 +36,7 @@ CONFIG_SYN_COOKIES=3Dy
 # CONFIG_INET_LRO is not set
 # CONFIG_IPV6 is not set
 CONFIG_BT=3Dm
-CONFIG_BT_L2CAP=3Dm
+CONFIG_BT_L2CAP=3Dy
 CONFIG_BT_RFCOMM=3Dm
 CONFIG_BT_RFCOMM_TTY=3Dy
 CONFIG_BT_HIDP=3Dm
diff -puN arch/mips/configs/lemote2f_defconfig~bluetooth-fix-build-warn=
ings-on-defconfigs arch/mips/configs/lemote2f_defconfig
--- a/arch/mips/configs/lemote2f_defconfig~bluetooth-fix-build-warnings=
-on-defconfigs
+++ a/arch/mips/configs/lemote2f_defconfig
@@ -86,8 +86,8 @@ CONFIG_NET_SCHED=3Dy
 CONFIG_NET_EMATCH=3Dy
 CONFIG_NET_CLS_ACT=3Dy
 CONFIG_BT=3Dm
-CONFIG_BT_L2CAP=3Dm
-CONFIG_BT_SCO=3Dm
+CONFIG_BT_L2CAP=3Dy
+CONFIG_BT_SCO=3Dy
 CONFIG_BT_RFCOMM=3Dm
 CONFIG_BT_RFCOMM_TTY=3Dy
 CONFIG_BT_BNEP=3Dm
diff -puN arch/mips/configs/mtx1_defconfig~bluetooth-fix-build-warnings=
-on-defconfigs arch/mips/configs/mtx1_defconfig
--- a/arch/mips/configs/mtx1_defconfig~bluetooth-fix-build-warnings-on-=
defconfigs
+++ a/arch/mips/configs/mtx1_defconfig
@@ -225,8 +225,8 @@ CONFIG_TOSHIBA_FIR=3Dm
 CONFIG_VLSI_FIR=3Dm
 CONFIG_MCS_FIR=3Dm
 CONFIG_BT=3Dm
-CONFIG_BT_L2CAP=3Dm
-CONFIG_BT_SCO=3Dm
+CONFIG_BT_L2CAP=3Dy
+CONFIG_BT_SCO=3Dy
 CONFIG_BT_RFCOMM=3Dm
 CONFIG_BT_RFCOMM_TTY=3Dy
 CONFIG_BT_BNEP=3Dm
diff -puN arch/powerpc/configs/c2k_defconfig~bluetooth-fix-build-warnin=
gs-on-defconfigs arch/powerpc/configs/c2k_defconfig
--- a/arch/powerpc/configs/c2k_defconfig~bluetooth-fix-build-warnings-o=
n-defconfigs
+++ a/arch/powerpc/configs/c2k_defconfig
@@ -132,8 +132,8 @@ CONFIG_NET_CLS_RSVP=3Dm
 CONFIG_NET_CLS_RSVP6=3Dm
 CONFIG_NET_CLS_IND=3Dy
 CONFIG_BT=3Dm
-CONFIG_BT_L2CAP=3Dm
-CONFIG_BT_SCO=3Dm
+CONFIG_BT_L2CAP=3Dy
+CONFIG_BT_SCO=3Dy
 CONFIG_BT_RFCOMM=3Dm
 CONFIG_BT_RFCOMM_TTY=3Dy
 CONFIG_BT_BNEP=3Dm
diff -puN arch/powerpc/configs/pmac32_defconfig~bluetooth-fix-build-war=
nings-on-defconfigs arch/powerpc/configs/pmac32_defconfig
--- a/arch/powerpc/configs/pmac32_defconfig~bluetooth-fix-build-warning=
s-on-defconfigs
+++ a/arch/powerpc/configs/pmac32_defconfig
@@ -112,8 +112,8 @@ CONFIG_IRDA_CACHE_LAST_LSAP=3Dy
 CONFIG_IRDA_FAST_RR=3Dy
 CONFIG_IRTTY_SIR=3Dm
 CONFIG_BT=3Dm
-CONFIG_BT_L2CAP=3Dm
-CONFIG_BT_SCO=3Dm
+CONFIG_BT_L2CAP=3Dy
+CONFIG_BT_SCO=3Dy
 CONFIG_BT_RFCOMM=3Dm
 CONFIG_BT_RFCOMM_TTY=3Dy
 CONFIG_BT_BNEP=3Dm
diff -puN arch/powerpc/configs/ppc6xx_defconfig~bluetooth-fix-build-war=
nings-on-defconfigs arch/powerpc/configs/ppc6xx_defconfig
--- a/arch/powerpc/configs/ppc6xx_defconfig~bluetooth-fix-build-warning=
s-on-defconfigs
+++ a/arch/powerpc/configs/ppc6xx_defconfig
@@ -351,8 +351,8 @@ CONFIG_VLSI_FIR=3Dm
 CONFIG_VIA_FIR=3Dm
 CONFIG_MCS_FIR=3Dm
 CONFIG_BT=3Dm
-CONFIG_BT_L2CAP=3Dm
-CONFIG_BT_SCO=3Dm
+CONFIG_BT_L2CAP=3Dy
+CONFIG_BT_SCO=3Dy
 CONFIG_BT_RFCOMM=3Dm
 CONFIG_BT_RFCOMM_TTY=3Dy
 CONFIG_BT_BNEP=3Dm
diff -puN arch/powerpc/configs/ps3_defconfig~bluetooth-fix-build-warnin=
gs-on-defconfigs arch/powerpc/configs/ps3_defconfig
--- a/arch/powerpc/configs/ps3_defconfig~bluetooth-fix-build-warnings-o=
n-defconfigs
+++ a/arch/powerpc/configs/ps3_defconfig
@@ -52,8 +52,8 @@ CONFIG_IP_PNP_DHCP=3Dy
 # CONFIG_INET_DIAG is not set
 CONFIG_IPV6=3Dy
 CONFIG_BT=3Dm
-CONFIG_BT_L2CAP=3Dm
-CONFIG_BT_SCO=3Dm
+CONFIG_BT_L2CAP=3Dy
+CONFIG_BT_SCO=3Dy
 CONFIG_BT_RFCOMM=3Dm
 CONFIG_BT_RFCOMM_TTY=3Dy
 CONFIG_BT_BNEP=3Dm
_

Patches currently in -mm which might be from wanlong.gao@gmail.com are

drivers-misc-sgi-gru-grufilec-fix-the-wrong-members-of-gru_chip.patch
avr32-s-irq_chip-irq_data-in-various-places.patch
xtensa-s-irq_chip-irq_data-in-various-places.patch
bluetooth-fix-build-warnings-on-defconfigs.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
