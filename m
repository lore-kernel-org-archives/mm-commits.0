From: akpm@linux-foundation.org
Subject: [merged] viresh-has-moved.patch removed from -mm tree
Date: Thu, 21 Jun 2012 12:25:38 -0700
Message-ID: <20120621192538.61B8BA00B0@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:50565 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760119Ab2FUTZk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jun 2012 15:25:40 -0400
Received: by qabg24 with SMTP id g24so242315qab.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Jun 2012 12:25:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viresh.linux@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Viresh has moved
has been removed from the -mm tree.  Its filename was
     viresh-has-moved.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
=46rom: Viresh Kumar <viresh.linux@gmail.com>
Subject: Viresh has moved

viresh.kumar@st.com email-id doesn't exist anymore as I have left the
company.  Replace ST's id with viresh.linux@gmail.com.

It also updates .mailmap file to fix address for 'git shortlog'

Signed-off-by: Viresh Kumar <viresh.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap                                           |    1=20
 Documentation/arm/SPEAr/overview.txt               |    2 -
 MAINTAINERS                                        |   18 +++++------
 arch/arm/boot/dts/spear1310-evb.dts                |    2 -
 arch/arm/boot/dts/spear1310.dtsi                   |    2 -
 arch/arm/boot/dts/spear1340-evb.dts                |    2 -
 arch/arm/boot/dts/spear1340.dtsi                   |    2 -
 arch/arm/boot/dts/spear13xx.dtsi                   |    2 -
 arch/arm/boot/dts/spear300-evb.dts                 |    2 -
 arch/arm/boot/dts/spear300.dtsi                    |    2 -
 arch/arm/boot/dts/spear310-evb.dts                 |    2 -
 arch/arm/boot/dts/spear310.dtsi                    |    2 -
 arch/arm/boot/dts/spear320-evb.dts                 |    2 -
 arch/arm/boot/dts/spear320.dtsi                    |    2 -
 arch/arm/boot/dts/spear3xx.dtsi                    |    2 -
 arch/arm/include/asm/hardware/sp810.h              |    2 -
 arch/arm/mach-spear13xx/include/mach/debug-macro.S |    2 -
 arch/arm/mach-spear13xx/include/mach/dma.h         |    2 -
 arch/arm/mach-spear13xx/include/mach/generic.h     |    2 -
 arch/arm/mach-spear13xx/include/mach/gpio.h        |    2 -
 arch/arm/mach-spear13xx/include/mach/irqs.h        |    2 -
 arch/arm/mach-spear13xx/include/mach/spear.h       |    2 -
 arch/arm/mach-spear13xx/include/mach/timex.h       |    2 -
 arch/arm/mach-spear13xx/include/mach/uncompress.h  |    2 -
 arch/arm/mach-spear13xx/spear1310.c                |    2 -
 arch/arm/mach-spear13xx/spear1340.c                |    2 -
 arch/arm/mach-spear13xx/spear13xx.c                |    2 -
 arch/arm/mach-spear3xx/include/mach/debug-macro.S  |    2 -
 arch/arm/mach-spear3xx/include/mach/generic.h      |    2 -
 arch/arm/mach-spear3xx/include/mach/gpio.h         |    2 -
 arch/arm/mach-spear3xx/include/mach/irqs.h         |    2 -
 arch/arm/mach-spear3xx/include/mach/misc_regs.h    |    2 -
 arch/arm/mach-spear3xx/include/mach/spear.h        |    2 -
 arch/arm/mach-spear3xx/include/mach/timex.h        |    2 -
 arch/arm/mach-spear3xx/include/mach/uncompress.h   |    2 -
 arch/arm/mach-spear3xx/spear300.c                  |    2 -
 arch/arm/mach-spear3xx/spear310.c                  |    2 -
 arch/arm/mach-spear3xx/spear320.c                  |    2 -
 arch/arm/mach-spear3xx/spear3xx.c                  |    2 -
 arch/arm/mach-spear6xx/include/mach/gpio.h         |    2 -
 arch/arm/mach-spear6xx/include/mach/misc_regs.h    |    2 -
 arch/arm/plat-spear/include/plat/debug-macro.S     |    2 -
 arch/arm/plat-spear/include/plat/pl080.h           |    2 -
 arch/arm/plat-spear/include/plat/shirq.h           |    2 -
 arch/arm/plat-spear/include/plat/timex.h           |    2 -
 arch/arm/plat-spear/include/plat/uncompress.h      |    2 -
 arch/arm/plat-spear/pl080.c                        |    2 -
 arch/arm/plat-spear/restart.c                      |    2 -
 arch/arm/plat-spear/shirq.c                        |    2 -
 drivers/ata/pata_arasan_cf.c                       |    4 +-
 drivers/clk/spear/clk-aux-synth.c                  |    2 -
 drivers/clk/spear/clk-frac-synth.c                 |    2 -
 drivers/clk/spear/clk-gpt-synth.c                  |    2 -
 drivers/clk/spear/clk-vco-pll.c                    |    2 -
 drivers/clk/spear/clk.c                            |    2 -
 drivers/clk/spear/clk.h                            |    2 -
 drivers/clk/spear/spear1310_clock.c                |    2 -
 drivers/clk/spear/spear1340_clock.c                |    2 -
 drivers/clk/spear/spear3xx_clock.c                 |    2 -
 drivers/clk/spear/spear6xx_clock.c                 |    2 -
 drivers/dma/dw_dmac.c                              |    2 -
 drivers/mfd/stmpe-i2c.c                            |    2 -
 drivers/mfd/stmpe-spi.c                            |    4 +-
 drivers/mmc/host/sdhci-spear.c                     |    4 +-
 drivers/pinctrl/spear/pinctrl-spear.c              |    2 -
 drivers/pinctrl/spear/pinctrl-spear.h              |    2 -
 drivers/pinctrl/spear/pinctrl-spear1310.c          |    4 +-
 drivers/pinctrl/spear/pinctrl-spear1340.c          |    4 +-
 drivers/pinctrl/spear/pinctrl-spear300.c           |    4 +-
 drivers/pinctrl/spear/pinctrl-spear310.c           |    4 +-
 drivers/pinctrl/spear/pinctrl-spear320.c           |    4 +-
 drivers/pinctrl/spear/pinctrl-spear3xx.c           |    2 -
 drivers/pinctrl/spear/pinctrl-spear3xx.h           |    2 -
 drivers/watchdog/sp805_wdt.c                       |    4 +-
 include/linux/mmc/sdhci-spear.h                    |    2 -
 include/linux/pata_arasan_cf_data.h                |    2 -
 76 files changed, 93 insertions(+), 92 deletions(-)

diff -puN .mailmap~viresh-has-moved .mailmap
--- a/.mailmap~viresh-has-moved
+++ a/.mailmap
@@ -111,6 +111,7 @@ Uwe Kleine-K=C3=B6nig <ukleinek@informatik.u
 Uwe Kleine-K=C3=B6nig <ukl@pengutronix.de>
 Uwe Kleine-K=C3=B6nig <Uwe.Kleine-Koenig@digi.com>
 Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
+Viresh Kumar <viresh.linux@gmail.com> <viresh.kumar@st.com>
 Takashi YOSHII <takashi.yoshii.zj@renesas.com>
 Yusuke Goda <goda.yusuke@renesas.com>
 Gustavo Padovan <gustavo@las.ic.unicamp.br>
diff -puN Documentation/arm/SPEAr/overview.txt~viresh-has-moved Documen=
tation/arm/SPEAr/overview.txt
--- a/Documentation/arm/SPEAr/overview.txt~viresh-has-moved
+++ a/Documentation/arm/SPEAr/overview.txt
@@ -60,4 +60,4 @@ Introduction
   Document Author
   ---------------
=20
-  Viresh Kumar <viresh.kumar@st.com>, (c) 2010-2012 ST Microelectronic=
s
+  Viresh Kumar <viresh.linux@gmail.com>, (c) 2010-2012 ST Microelectro=
nics
diff -puN MAINTAINERS~viresh-has-moved MAINTAINERS
--- a/MAINTAINERS~viresh-has-moved
+++ a/MAINTAINERS
@@ -572,7 +572,7 @@ F:	drivers/net/appletalk/
 F:	net/appletalk/
=20
 ARASAN COMPACT FLASH PATA CONTROLLER
-M:	Viresh Kumar <viresh.kumar@st.com>
+M:     Viresh Kumar <viresh.linux@gmail.com>
 L:	linux-ide@vger.kernel.org
 S:	Maintained
 F:	include/linux/pata_arasan_cf_data.h
@@ -5296,7 +5296,7 @@ S:	Maintained
 F:	drivers/pinctrl/
=20
 PIN CONTROLLER - ST SPEAR
-M:	Viresh Kumar <viresh.kumar@st.com>
+M:     Viresh Kumar <viresh.linux@gmail.com>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers=
)
 W:	http://www.st.com/spear
@@ -5874,7 +5874,7 @@ S:	Maintained
 F:	drivers/tty/serial
=20
 SYNOPSYS DESIGNWARE DMAC DRIVER
-M:	Viresh Kumar <viresh.kumar@st.com>
+M:     Viresh Kumar <viresh.linux@gmail.com>
 S:	Maintained
 F:	include/linux/dw_dmac.h
 F:	drivers/dma/dw_dmac_regs.h
@@ -6022,7 +6022,7 @@ S:	Maintained
 F:	drivers/mmc/host/sdhci-s3c.c
=20
 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) ST SPEAR DRIVER
-M:	Viresh Kumar <viresh.kumar@st.com>
+M:     Viresh Kumar <viresh.linux@gmail.com>
 L:	spear-devel@list.st.com
 L:	linux-mmc@vger.kernel.org
 S:	Maintained
@@ -6378,7 +6378,7 @@ S:	Maintained
 F:	include/linux/compiler.h
=20
 SPEAR PLATFORM SUPPORT
-M:	Viresh Kumar <viresh.kumar@st.com>
+M:     Viresh Kumar <viresh.linux@gmail.com>
 M:	Shiraz Hashim <shiraz.hashim@st.com>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers=
)
@@ -6387,7 +6387,7 @@ S:	Maintained
 F:	arch/arm/plat-spear/
=20
 SPEAR13XX MACHINE SUPPORT
-M:	Viresh Kumar <viresh.kumar@st.com>
+M:     Viresh Kumar <viresh.linux@gmail.com>
 M:	Shiraz Hashim <shiraz.hashim@st.com>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers=
)
@@ -6396,7 +6396,7 @@ S:	Maintained
 F:	arch/arm/mach-spear13xx/
=20
 SPEAR3XX MACHINE SUPPORT
-M:	Viresh Kumar <viresh.kumar@st.com>
+M:     Viresh Kumar <viresh.linux@gmail.com>
 M:	Shiraz Hashim <shiraz.hashim@st.com>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers=
)
@@ -6407,7 +6407,7 @@ F:	arch/arm/mach-spear3xx/
 SPEAR6XX MACHINE SUPPORT
 M:	Rajeev Kumar <rajeev-dlh.kumar@st.com>
 M:	Shiraz Hashim <shiraz.hashim@st.com>
-M:	Viresh Kumar <viresh.kumar@st.com>
+M:     Viresh Kumar <viresh.linux@gmail.com>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers=
)
 W:	http://www.st.com/spear
@@ -6415,7 +6415,7 @@ S:	Maintained
 F:	arch/arm/mach-spear6xx/
=20
 SPEAR CLOCK FRAMEWORK SUPPORT
-M:	Viresh Kumar <viresh.kumar@st.com>
+M:     Viresh Kumar <viresh.linux@gmail.com>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers=
)
 W:	http://www.st.com/spear
diff -puN arch/arm/boot/dts/spear1310-evb.dts~viresh-has-moved arch/arm=
/boot/dts/spear1310-evb.dts
--- a/arch/arm/boot/dts/spear1310-evb.dts~viresh-has-moved
+++ a/arch/arm/boot/dts/spear1310-evb.dts
@@ -1,7 +1,7 @@
 /*
  * DTS file for SPEAr1310 Evaluation Baord
  *
- * Copyright 2012 Viresh Kumar <viresh.kumar@st.com>
+ * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff -puN arch/arm/boot/dts/spear1310.dtsi~viresh-has-moved arch/arm/bo=
ot/dts/spear1310.dtsi
--- a/arch/arm/boot/dts/spear1310.dtsi~viresh-has-moved
+++ a/arch/arm/boot/dts/spear1310.dtsi
@@ -1,7 +1,7 @@
 /*
  * DTS file for all SPEAr1310 SoCs
  *
- * Copyright 2012 Viresh Kumar <viresh.kumar@st.com>
+ * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff -puN arch/arm/boot/dts/spear1340-evb.dts~viresh-has-moved arch/arm=
/boot/dts/spear1340-evb.dts
--- a/arch/arm/boot/dts/spear1340-evb.dts~viresh-has-moved
+++ a/arch/arm/boot/dts/spear1340-evb.dts
@@ -1,7 +1,7 @@
 /*
  * DTS file for SPEAr1340 Evaluation Baord
  *
- * Copyright 2012 Viresh Kumar <viresh.kumar@st.com>
+ * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff -puN arch/arm/boot/dts/spear1340.dtsi~viresh-has-moved arch/arm/bo=
ot/dts/spear1340.dtsi
--- a/arch/arm/boot/dts/spear1340.dtsi~viresh-has-moved
+++ a/arch/arm/boot/dts/spear1340.dtsi
@@ -1,7 +1,7 @@
 /*
  * DTS file for all SPEAr1340 SoCs
  *
- * Copyright 2012 Viresh Kumar <viresh.kumar@st.com>
+ * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff -puN arch/arm/boot/dts/spear13xx.dtsi~viresh-has-moved arch/arm/bo=
ot/dts/spear13xx.dtsi
--- a/arch/arm/boot/dts/spear13xx.dtsi~viresh-has-moved
+++ a/arch/arm/boot/dts/spear13xx.dtsi
@@ -1,7 +1,7 @@
 /*
  * DTS file for all SPEAr13xx SoCs
  *
- * Copyright 2012 Viresh Kumar <viresh.kumar@st.com>
+ * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff -puN arch/arm/boot/dts/spear300-evb.dts~viresh-has-moved arch/arm/=
boot/dts/spear300-evb.dts
--- a/arch/arm/boot/dts/spear300-evb.dts~viresh-has-moved
+++ a/arch/arm/boot/dts/spear300-evb.dts
@@ -1,7 +1,7 @@
 /*
  * DTS file for SPEAr300 Evaluation Baord
  *
- * Copyright 2012 Viresh Kumar <viresh.kumar@st.com>
+ * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff -puN arch/arm/boot/dts/spear300.dtsi~viresh-has-moved arch/arm/boo=
t/dts/spear300.dtsi
--- a/arch/arm/boot/dts/spear300.dtsi~viresh-has-moved
+++ a/arch/arm/boot/dts/spear300.dtsi
@@ -1,7 +1,7 @@
 /*
  * DTS file for SPEAr300 SoC
  *
- * Copyright 2012 Viresh Kumar <viresh.kumar@st.com>
+ * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff -puN arch/arm/boot/dts/spear310-evb.dts~viresh-has-moved arch/arm/=
boot/dts/spear310-evb.dts
--- a/arch/arm/boot/dts/spear310-evb.dts~viresh-has-moved
+++ a/arch/arm/boot/dts/spear310-evb.dts
@@ -1,7 +1,7 @@
 /*
  * DTS file for SPEAr310 Evaluation Baord
  *
- * Copyright 2012 Viresh Kumar <viresh.kumar@st.com>
+ * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff -puN arch/arm/boot/dts/spear310.dtsi~viresh-has-moved arch/arm/boo=
t/dts/spear310.dtsi
--- a/arch/arm/boot/dts/spear310.dtsi~viresh-has-moved
+++ a/arch/arm/boot/dts/spear310.dtsi
@@ -1,7 +1,7 @@
 /*
  * DTS file for SPEAr310 SoC
  *
- * Copyright 2012 Viresh Kumar <viresh.kumar@st.com>
+ * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff -puN arch/arm/boot/dts/spear320-evb.dts~viresh-has-moved arch/arm/=
boot/dts/spear320-evb.dts
--- a/arch/arm/boot/dts/spear320-evb.dts~viresh-has-moved
+++ a/arch/arm/boot/dts/spear320-evb.dts
@@ -1,7 +1,7 @@
 /*
  * DTS file for SPEAr320 Evaluation Baord
  *
- * Copyright 2012 Viresh Kumar <viresh.kumar@st.com>
+ * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff -puN arch/arm/boot/dts/spear320.dtsi~viresh-has-moved arch/arm/boo=
t/dts/spear320.dtsi
--- a/arch/arm/boot/dts/spear320.dtsi~viresh-has-moved
+++ a/arch/arm/boot/dts/spear320.dtsi
@@ -1,7 +1,7 @@
 /*
  * DTS file for SPEAr320 SoC
  *
- * Copyright 2012 Viresh Kumar <viresh.kumar@st.com>
+ * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff -puN arch/arm/boot/dts/spear3xx.dtsi~viresh-has-moved arch/arm/boo=
t/dts/spear3xx.dtsi
--- a/arch/arm/boot/dts/spear3xx.dtsi~viresh-has-moved
+++ a/arch/arm/boot/dts/spear3xx.dtsi
@@ -1,7 +1,7 @@
 /*
  * DTS file for all SPEAr3xx SoCs
  *
- * Copyright 2012 Viresh Kumar <viresh.kumar@st.com>
+ * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff -puN arch/arm/include/asm/hardware/sp810.h~viresh-has-moved arch/a=
rm/include/asm/hardware/sp810.h
--- a/arch/arm/include/asm/hardware/sp810.h~viresh-has-moved
+++ a/arch/arm/include/asm/hardware/sp810.h
@@ -4,7 +4,7 @@
  * ARM PrimeXsys System Controller SP810 header file
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear13xx/include/mach/debug-macro.S~viresh-has=
-moved arch/arm/mach-spear13xx/include/mach/debug-macro.S
--- a/arch/arm/mach-spear13xx/include/mach/debug-macro.S~viresh-has-mov=
ed
+++ a/arch/arm/mach-spear13xx/include/mach/debug-macro.S
@@ -4,7 +4,7 @@
  * Debugging macro include header spear13xx machine family
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear13xx/include/mach/dma.h~viresh-has-moved a=
rch/arm/mach-spear13xx/include/mach/dma.h
--- a/arch/arm/mach-spear13xx/include/mach/dma.h~viresh-has-moved
+++ a/arch/arm/mach-spear13xx/include/mach/dma.h
@@ -4,7 +4,7 @@
  * DMA information for SPEAr13xx machine family
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear13xx/include/mach/generic.h~viresh-has-mov=
ed arch/arm/mach-spear13xx/include/mach/generic.h
--- a/arch/arm/mach-spear13xx/include/mach/generic.h~viresh-has-moved
+++ a/arch/arm/mach-spear13xx/include/mach/generic.h
@@ -4,7 +4,7 @@
  * spear13xx machine family generic header file
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear13xx/include/mach/gpio.h~viresh-has-moved =
arch/arm/mach-spear13xx/include/mach/gpio.h
--- a/arch/arm/mach-spear13xx/include/mach/gpio.h~viresh-has-moved
+++ a/arch/arm/mach-spear13xx/include/mach/gpio.h
@@ -4,7 +4,7 @@
  * GPIO macros for SPEAr13xx machine family
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear13xx/include/mach/irqs.h~viresh-has-moved =
arch/arm/mach-spear13xx/include/mach/irqs.h
--- a/arch/arm/mach-spear13xx/include/mach/irqs.h~viresh-has-moved
+++ a/arch/arm/mach-spear13xx/include/mach/irqs.h
@@ -4,7 +4,7 @@
  * IRQ helper macros for spear13xx machine family
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear13xx/include/mach/spear.h~viresh-has-moved=
 arch/arm/mach-spear13xx/include/mach/spear.h
--- a/arch/arm/mach-spear13xx/include/mach/spear.h~viresh-has-moved
+++ a/arch/arm/mach-spear13xx/include/mach/spear.h
@@ -4,7 +4,7 @@
  * spear13xx Machine family specific definition
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear13xx/include/mach/timex.h~viresh-has-moved=
 arch/arm/mach-spear13xx/include/mach/timex.h
--- a/arch/arm/mach-spear13xx/include/mach/timex.h~viresh-has-moved
+++ a/arch/arm/mach-spear13xx/include/mach/timex.h
@@ -4,7 +4,7 @@
  * SPEAr3XX machine family specific timex definitions
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear13xx/include/mach/uncompress.h~viresh-has-=
moved arch/arm/mach-spear13xx/include/mach/uncompress.h
--- a/arch/arm/mach-spear13xx/include/mach/uncompress.h~viresh-has-move=
d
+++ a/arch/arm/mach-spear13xx/include/mach/uncompress.h
@@ -4,7 +4,7 @@
  * Serial port stubs for kernel decompress status messages
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear13xx/spear1310.c~viresh-has-moved arch/arm=
/mach-spear13xx/spear1310.c
--- a/arch/arm/mach-spear13xx/spear1310.c~viresh-has-moved
+++ a/arch/arm/mach-spear13xx/spear1310.c
@@ -4,7 +4,7 @@
  * SPEAr1310 machine source file
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear13xx/spear1340.c~viresh-has-moved arch/arm=
/mach-spear13xx/spear1340.c
--- a/arch/arm/mach-spear13xx/spear1340.c~viresh-has-moved
+++ a/arch/arm/mach-spear13xx/spear1340.c
@@ -4,7 +4,7 @@
  * SPEAr1340 machine source file
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear13xx/spear13xx.c~viresh-has-moved arch/arm=
/mach-spear13xx/spear13xx.c
--- a/arch/arm/mach-spear13xx/spear13xx.c~viresh-has-moved
+++ a/arch/arm/mach-spear13xx/spear13xx.c
@@ -4,7 +4,7 @@
  * SPEAr13XX machines common source file
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear3xx/include/mach/debug-macro.S~viresh-has-=
moved arch/arm/mach-spear3xx/include/mach/debug-macro.S
--- a/arch/arm/mach-spear3xx/include/mach/debug-macro.S~viresh-has-move=
d
+++ a/arch/arm/mach-spear3xx/include/mach/debug-macro.S
@@ -4,7 +4,7 @@
  * Debugging macro include header spear3xx machine family
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar<viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear3xx/include/mach/generic.h~viresh-has-move=
d arch/arm/mach-spear3xx/include/mach/generic.h
--- a/arch/arm/mach-spear3xx/include/mach/generic.h~viresh-has-moved
+++ a/arch/arm/mach-spear3xx/include/mach/generic.h
@@ -4,7 +4,7 @@
  * SPEAr3XX machine family generic header file
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar<viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear3xx/include/mach/gpio.h~viresh-has-moved a=
rch/arm/mach-spear3xx/include/mach/gpio.h
--- a/arch/arm/mach-spear3xx/include/mach/gpio.h~viresh-has-moved
+++ a/arch/arm/mach-spear3xx/include/mach/gpio.h
@@ -4,7 +4,7 @@
  * GPIO macros for SPEAr3xx machine family
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar<viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear3xx/include/mach/irqs.h~viresh-has-moved a=
rch/arm/mach-spear3xx/include/mach/irqs.h
--- a/arch/arm/mach-spear3xx/include/mach/irqs.h~viresh-has-moved
+++ a/arch/arm/mach-spear3xx/include/mach/irqs.h
@@ -4,7 +4,7 @@
  * IRQ helper macros for SPEAr3xx machine family
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear3xx/include/mach/misc_regs.h~viresh-has-mo=
ved arch/arm/mach-spear3xx/include/mach/misc_regs.h
--- a/arch/arm/mach-spear3xx/include/mach/misc_regs.h~viresh-has-moved
+++ a/arch/arm/mach-spear3xx/include/mach/misc_regs.h
@@ -4,7 +4,7 @@
  * Miscellaneous registers definitions for SPEAr3xx machine family
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear3xx/include/mach/spear.h~viresh-has-moved =
arch/arm/mach-spear3xx/include/mach/spear.h
--- a/arch/arm/mach-spear3xx/include/mach/spear.h~viresh-has-moved
+++ a/arch/arm/mach-spear3xx/include/mach/spear.h
@@ -4,7 +4,7 @@
  * SPEAr3xx Machine family specific definition
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear3xx/include/mach/timex.h~viresh-has-moved =
arch/arm/mach-spear3xx/include/mach/timex.h
--- a/arch/arm/mach-spear3xx/include/mach/timex.h~viresh-has-moved
+++ a/arch/arm/mach-spear3xx/include/mach/timex.h
@@ -4,7 +4,7 @@
  * SPEAr3XX machine family specific timex definitions
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear3xx/include/mach/uncompress.h~viresh-has-m=
oved arch/arm/mach-spear3xx/include/mach/uncompress.h
--- a/arch/arm/mach-spear3xx/include/mach/uncompress.h~viresh-has-moved
+++ a/arch/arm/mach-spear3xx/include/mach/uncompress.h
@@ -4,7 +4,7 @@
  * Serial port stubs for kernel decompress status messages
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear3xx/spear300.c~viresh-has-moved arch/arm/m=
ach-spear3xx/spear300.c
--- a/arch/arm/mach-spear3xx/spear300.c~viresh-has-moved
+++ a/arch/arm/mach-spear3xx/spear300.c
@@ -4,7 +4,7 @@
  * SPEAr300 machine source file
  *
  * Copyright (C) 2009-2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear3xx/spear310.c~viresh-has-moved arch/arm/m=
ach-spear3xx/spear310.c
--- a/arch/arm/mach-spear3xx/spear310.c~viresh-has-moved
+++ a/arch/arm/mach-spear3xx/spear310.c
@@ -4,7 +4,7 @@
  * SPEAr310 machine source file
  *
  * Copyright (C) 2009-2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear3xx/spear320.c~viresh-has-moved arch/arm/m=
ach-spear3xx/spear320.c
--- a/arch/arm/mach-spear3xx/spear320.c~viresh-has-moved
+++ a/arch/arm/mach-spear3xx/spear320.c
@@ -4,7 +4,7 @@
  * SPEAr320 machine source file
  *
  * Copyright (C) 2009-2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear3xx/spear3xx.c~viresh-has-moved arch/arm/m=
ach-spear3xx/spear3xx.c
--- a/arch/arm/mach-spear3xx/spear3xx.c~viresh-has-moved
+++ a/arch/arm/mach-spear3xx/spear3xx.c
@@ -4,7 +4,7 @@
  * SPEAr3XX machines common source file
  *
  * Copyright (C) 2009-2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear6xx/include/mach/gpio.h~viresh-has-moved a=
rch/arm/mach-spear6xx/include/mach/gpio.h
--- a/arch/arm/mach-spear6xx/include/mach/gpio.h~viresh-has-moved
+++ a/arch/arm/mach-spear6xx/include/mach/gpio.h
@@ -4,7 +4,7 @@
  * GPIO macros for SPEAr6xx machine family
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear6xx/include/mach/misc_regs.h~viresh-has-mo=
ved arch/arm/mach-spear6xx/include/mach/misc_regs.h
--- a/arch/arm/mach-spear6xx/include/mach/misc_regs.h~viresh-has-moved
+++ a/arch/arm/mach-spear6xx/include/mach/misc_regs.h
@@ -4,7 +4,7 @@
  * Miscellaneous registers definitions for SPEAr6xx machine family
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/plat-spear/include/plat/debug-macro.S~viresh-has-mov=
ed arch/arm/plat-spear/include/plat/debug-macro.S
--- a/arch/arm/plat-spear/include/plat/debug-macro.S~viresh-has-moved
+++ a/arch/arm/plat-spear/include/plat/debug-macro.S
@@ -4,7 +4,7 @@
  * Debugging macro include header for spear platform
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/plat-spear/include/plat/pl080.h~viresh-has-moved arc=
h/arm/plat-spear/include/plat/pl080.h
--- a/arch/arm/plat-spear/include/plat/pl080.h~viresh-has-moved
+++ a/arch/arm/plat-spear/include/plat/pl080.h
@@ -4,7 +4,7 @@
  * DMAC pl080 definitions for SPEAr platform
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/plat-spear/include/plat/shirq.h~viresh-has-moved arc=
h/arm/plat-spear/include/plat/shirq.h
--- a/arch/arm/plat-spear/include/plat/shirq.h~viresh-has-moved
+++ a/arch/arm/plat-spear/include/plat/shirq.h
@@ -4,7 +4,7 @@
  * SPEAr platform shared irq layer header file
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/plat-spear/include/plat/timex.h~viresh-has-moved arc=
h/arm/plat-spear/include/plat/timex.h
--- a/arch/arm/plat-spear/include/plat/timex.h~viresh-has-moved
+++ a/arch/arm/plat-spear/include/plat/timex.h
@@ -4,7 +4,7 @@
  * SPEAr platform specific timex definitions
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/plat-spear/include/plat/uncompress.h~viresh-has-move=
d arch/arm/plat-spear/include/plat/uncompress.h
--- a/arch/arm/plat-spear/include/plat/uncompress.h~viresh-has-moved
+++ a/arch/arm/plat-spear/include/plat/uncompress.h
@@ -4,7 +4,7 @@
  * Serial port stubs for kernel decompress status messages
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/plat-spear/pl080.c~viresh-has-moved arch/arm/plat-sp=
ear/pl080.c
--- a/arch/arm/plat-spear/pl080.c~viresh-has-moved
+++ a/arch/arm/plat-spear/pl080.c
@@ -4,7 +4,7 @@
  * DMAC pl080 definitions for SPEAr platform
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/plat-spear/restart.c~viresh-has-moved arch/arm/plat-=
spear/restart.c
--- a/arch/arm/plat-spear/restart.c~viresh-has-moved
+++ a/arch/arm/plat-spear/restart.c
@@ -4,7 +4,7 @@
  * SPEAr platform specific restart functions
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/plat-spear/shirq.c~viresh-has-moved arch/arm/plat-sp=
ear/shirq.c
--- a/arch/arm/plat-spear/shirq.c~viresh-has-moved
+++ a/arch/arm/plat-spear/shirq.c
@@ -4,7 +4,7 @@
  * SPEAr platform shared irq layer source file
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/ata/pata_arasan_cf.c~viresh-has-moved drivers/ata/pat=
a_arasan_cf.c
--- a/drivers/ata/pata_arasan_cf.c~viresh-has-moved
+++ a/drivers/ata/pata_arasan_cf.c
@@ -4,7 +4,7 @@
  * Arasan Compact Flash host controller source file
  *
  * Copyright (C) 2011 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
@@ -959,7 +959,7 @@ static struct platform_driver arasan_cf_
=20
 module_platform_driver(arasan_cf_driver);
=20
-MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");
+MODULE_AUTHOR("Viresh Kumar <viresh.linux@gmail.com>");
 MODULE_DESCRIPTION("Arasan ATA Compact Flash driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:" DRIVER_NAME);
diff -puN drivers/clk/spear/clk-aux-synth.c~viresh-has-moved drivers/cl=
k/spear/clk-aux-synth.c
--- a/drivers/clk/spear/clk-aux-synth.c~viresh-has-moved
+++ a/drivers/clk/spear/clk-aux-synth.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/clk/spear/clk-frac-synth.c~viresh-has-moved drivers/c=
lk/spear/clk-frac-synth.c
--- a/drivers/clk/spear/clk-frac-synth.c~viresh-has-moved
+++ a/drivers/clk/spear/clk-frac-synth.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/clk/spear/clk-gpt-synth.c~viresh-has-moved drivers/cl=
k/spear/clk-gpt-synth.c
--- a/drivers/clk/spear/clk-gpt-synth.c~viresh-has-moved
+++ a/drivers/clk/spear/clk-gpt-synth.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/clk/spear/clk-vco-pll.c~viresh-has-moved drivers/clk/=
spear/clk-vco-pll.c
--- a/drivers/clk/spear/clk-vco-pll.c~viresh-has-moved
+++ a/drivers/clk/spear/clk-vco-pll.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/clk/spear/clk.c~viresh-has-moved drivers/clk/spear/cl=
k.c
--- a/drivers/clk/spear/clk.c~viresh-has-moved
+++ a/drivers/clk/spear/clk.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/clk/spear/clk.h~viresh-has-moved drivers/clk/spear/cl=
k.h
--- a/drivers/clk/spear/clk.h~viresh-has-moved
+++ a/drivers/clk/spear/clk.h
@@ -2,7 +2,7 @@
  * Clock framework definitions for SPEAr platform
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/clk/spear/spear1310_clock.c~viresh-has-moved drivers/=
clk/spear/spear1310_clock.c
--- a/drivers/clk/spear/spear1310_clock.c~viresh-has-moved
+++ a/drivers/clk/spear/spear1310_clock.c
@@ -4,7 +4,7 @@
  * SPEAr1310 machine clock framework source file
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/clk/spear/spear1340_clock.c~viresh-has-moved drivers/=
clk/spear/spear1340_clock.c
--- a/drivers/clk/spear/spear1340_clock.c~viresh-has-moved
+++ a/drivers/clk/spear/spear1340_clock.c
@@ -4,7 +4,7 @@
  * SPEAr1340 machine clock framework source file
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/clk/spear/spear3xx_clock.c~viresh-has-moved drivers/c=
lk/spear/spear3xx_clock.c
--- a/drivers/clk/spear/spear3xx_clock.c~viresh-has-moved
+++ a/drivers/clk/spear/spear3xx_clock.c
@@ -2,7 +2,7 @@
  * SPEAr3xx machines clock framework source file
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/clk/spear/spear6xx_clock.c~viresh-has-moved drivers/c=
lk/spear/spear6xx_clock.c
--- a/drivers/clk/spear/spear6xx_clock.c~viresh-has-moved
+++ a/drivers/clk/spear/spear6xx_clock.c
@@ -2,7 +2,7 @@
  * SPEAr6xx machines clock framework source file
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/dma/dw_dmac.c~viresh-has-moved drivers/dma/dw_dmac.c
--- a/drivers/dma/dw_dmac.c~viresh-has-moved
+++ a/drivers/dma/dw_dmac.c
@@ -1626,4 +1626,4 @@ module_exit(dw_exit);
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Synopsys DesignWare DMA Controller driver");
 MODULE_AUTHOR("Haavard Skinnemoen (Atmel)");
-MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");
+MODULE_AUTHOR("Viresh Kumar <viresh.linux@gmail.com>");
diff -puN drivers/mfd/stmpe-i2c.c~viresh-has-moved drivers/mfd/stmpe-i2=
c.c
--- a/drivers/mfd/stmpe-i2c.c~viresh-has-moved
+++ a/drivers/mfd/stmpe-i2c.c
@@ -6,7 +6,7 @@
  *
  * License Terms: GNU General Public License, version 2
  * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsso=
n
- * Author: Viresh Kumar <viresh.kumar@st.com> for ST Microelectronics
+ * Author: Viresh Kumar <viresh.linux@gmail.com> for ST Microelectroni=
cs
  */
=20
 #include <linux/i2c.h>
diff -puN drivers/mfd/stmpe-spi.c~viresh-has-moved drivers/mfd/stmpe-sp=
i.c
--- a/drivers/mfd/stmpe-spi.c~viresh-has-moved
+++ a/drivers/mfd/stmpe-spi.c
@@ -4,7 +4,7 @@
  * Copyright (C) ST Microelectronics SA 2011
  *
  * License Terms: GNU General Public License, version 2
- * Author: Viresh Kumar <viresh.kumar@st.com> for ST Microelectronics
+ * Author: Viresh Kumar <viresh.linux@gmail.com> for ST Microelectroni=
cs
  */
=20
 #include <linux/spi/spi.h>
@@ -146,4 +146,4 @@ module_exit(stmpe_exit);
=20
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("STMPE MFD SPI Interface Driver");
-MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");
+MODULE_AUTHOR("Viresh Kumar <viresh.linux@gmail.com>");
diff -puN drivers/mmc/host/sdhci-spear.c~viresh-has-moved drivers/mmc/h=
ost/sdhci-spear.c
--- a/drivers/mmc/host/sdhci-spear.c~viresh-has-moved
+++ a/drivers/mmc/host/sdhci-spear.c
@@ -4,7 +4,7 @@
  * Support of SDHCI platform devices for spear soc family
  *
  * Copyright (C) 2010 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * Inspired by sdhci-pltfm.c
  *
@@ -289,5 +289,5 @@ static struct platform_driver sdhci_driv
 module_platform_driver(sdhci_driver);
=20
 MODULE_DESCRIPTION("SPEAr Secure Digital Host Controller Interface dri=
ver");
-MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");
+MODULE_AUTHOR("Viresh Kumar <viresh.linux@gmail.com>");
 MODULE_LICENSE("GPL v2");
diff -puN drivers/pinctrl/spear/pinctrl-spear.c~viresh-has-moved driver=
s/pinctrl/spear/pinctrl-spear.c
--- a/drivers/pinctrl/spear/pinctrl-spear.c~viresh-has-moved
+++ a/drivers/pinctrl/spear/pinctrl-spear.c
@@ -2,7 +2,7 @@
  * Driver for the ST Microelectronics SPEAr pinmux
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * Inspired from:
  * - U300 Pinctl drivers
diff -puN drivers/pinctrl/spear/pinctrl-spear.h~viresh-has-moved driver=
s/pinctrl/spear/pinctrl-spear.h
--- a/drivers/pinctrl/spear/pinctrl-spear.h~viresh-has-moved
+++ a/drivers/pinctrl/spear/pinctrl-spear.h
@@ -2,7 +2,7 @@
  * Driver header file for the ST Microelectronics SPEAr pinmux
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/pinctrl/spear/pinctrl-spear1310.c~viresh-has-moved dr=
ivers/pinctrl/spear/pinctrl-spear1310.c
--- a/drivers/pinctrl/spear/pinctrl-spear1310.c~viresh-has-moved
+++ a/drivers/pinctrl/spear/pinctrl-spear1310.c
@@ -2,7 +2,7 @@
  * Driver for the ST Microelectronics SPEAr1310 pinmux
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
@@ -2192,7 +2192,7 @@ static void __exit spear1310_pinctrl_exi
 }
 module_exit(spear1310_pinctrl_exit);
=20
-MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");
+MODULE_AUTHOR("Viresh Kumar <viresh.linux@gmail.com>");
 MODULE_DESCRIPTION("ST Microelectronics SPEAr1310 pinctrl driver");
 MODULE_LICENSE("GPL v2");
 MODULE_DEVICE_TABLE(of, spear1310_pinctrl_of_match);
diff -puN drivers/pinctrl/spear/pinctrl-spear1340.c~viresh-has-moved dr=
ivers/pinctrl/spear/pinctrl-spear1340.c
--- a/drivers/pinctrl/spear/pinctrl-spear1340.c~viresh-has-moved
+++ a/drivers/pinctrl/spear/pinctrl-spear1340.c
@@ -2,7 +2,7 @@
  * Driver for the ST Microelectronics SPEAr1340 pinmux
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
@@ -1983,7 +1983,7 @@ static void __exit spear1340_pinctrl_exi
 }
 module_exit(spear1340_pinctrl_exit);
=20
-MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");
+MODULE_AUTHOR("Viresh Kumar <viresh.linux@gmail.com>");
 MODULE_DESCRIPTION("ST Microelectronics SPEAr1340 pinctrl driver");
 MODULE_LICENSE("GPL v2");
 MODULE_DEVICE_TABLE(of, spear1340_pinctrl_of_match);
diff -puN drivers/pinctrl/spear/pinctrl-spear300.c~viresh-has-moved dri=
vers/pinctrl/spear/pinctrl-spear300.c
--- a/drivers/pinctrl/spear/pinctrl-spear300.c~viresh-has-moved
+++ a/drivers/pinctrl/spear/pinctrl-spear300.c
@@ -2,7 +2,7 @@
  * Driver for the ST Microelectronics SPEAr300 pinmux
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
@@ -702,7 +702,7 @@ static void __exit spear300_pinctrl_exit
 }
 module_exit(spear300_pinctrl_exit);
=20
-MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");
+MODULE_AUTHOR("Viresh Kumar <viresh.linux@gmail.com>");
 MODULE_DESCRIPTION("ST Microelectronics SPEAr300 pinctrl driver");
 MODULE_LICENSE("GPL v2");
 MODULE_DEVICE_TABLE(of, spear300_pinctrl_of_match);
diff -puN drivers/pinctrl/spear/pinctrl-spear310.c~viresh-has-moved dri=
vers/pinctrl/spear/pinctrl-spear310.c
--- a/drivers/pinctrl/spear/pinctrl-spear310.c~viresh-has-moved
+++ a/drivers/pinctrl/spear/pinctrl-spear310.c
@@ -2,7 +2,7 @@
  * Driver for the ST Microelectronics SPEAr310 pinmux
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
@@ -425,7 +425,7 @@ static void __exit spear310_pinctrl_exit
 }
 module_exit(spear310_pinctrl_exit);
=20
-MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");
+MODULE_AUTHOR("Viresh Kumar <viresh.linux@gmail.com>");
 MODULE_DESCRIPTION("ST Microelectronics SPEAr310 pinctrl driver");
 MODULE_LICENSE("GPL v2");
 MODULE_DEVICE_TABLE(of, SPEAr310_pinctrl_of_match);
diff -puN drivers/pinctrl/spear/pinctrl-spear320.c~viresh-has-moved dri=
vers/pinctrl/spear/pinctrl-spear320.c
--- a/drivers/pinctrl/spear/pinctrl-spear320.c~viresh-has-moved
+++ a/drivers/pinctrl/spear/pinctrl-spear320.c
@@ -2,7 +2,7 @@
  * Driver for the ST Microelectronics SPEAr320 pinmux
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
@@ -3462,7 +3462,7 @@ static void __exit spear320_pinctrl_exit
 }
 module_exit(spear320_pinctrl_exit);
=20
-MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");
+MODULE_AUTHOR("Viresh Kumar <viresh.linux@gmail.com>");
 MODULE_DESCRIPTION("ST Microelectronics SPEAr320 pinctrl driver");
 MODULE_LICENSE("GPL v2");
 MODULE_DEVICE_TABLE(of, spear320_pinctrl_of_match);
diff -puN drivers/pinctrl/spear/pinctrl-spear3xx.c~viresh-has-moved dri=
vers/pinctrl/spear/pinctrl-spear3xx.c
--- a/drivers/pinctrl/spear/pinctrl-spear3xx.c~viresh-has-moved
+++ a/drivers/pinctrl/spear/pinctrl-spear3xx.c
@@ -2,7 +2,7 @@
  * Driver for the ST Microelectronics SPEAr3xx pinmux
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/pinctrl/spear/pinctrl-spear3xx.h~viresh-has-moved dri=
vers/pinctrl/spear/pinctrl-spear3xx.h
--- a/drivers/pinctrl/spear/pinctrl-spear3xx.h~viresh-has-moved
+++ a/drivers/pinctrl/spear/pinctrl-spear3xx.h
@@ -2,7 +2,7 @@
  * Header file for the ST Microelectronics SPEAr3xx pinmux
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/watchdog/sp805_wdt.c~viresh-has-moved drivers/watchdo=
g/sp805_wdt.c
--- a/drivers/watchdog/sp805_wdt.c~viresh-has-moved
+++ a/drivers/watchdog/sp805_wdt.c
@@ -4,7 +4,7 @@
  * Watchdog driver for ARM SP805 watchdog module
  *
  * Copyright (C) 2010 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2 or later. This program is licensed "as is" withou=
t any
@@ -331,6 +331,6 @@ static struct amba_driver sp805_wdt_driv
=20
 module_amba_driver(sp805_wdt_driver);
=20
-MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");
+MODULE_AUTHOR("Viresh Kumar <viresh.linux@gmail.com>");
 MODULE_DESCRIPTION("ARM SP805 Watchdog Driver");
 MODULE_LICENSE("GPL");
diff -puN include/linux/mmc/sdhci-spear.h~viresh-has-moved include/linu=
x/mmc/sdhci-spear.h
--- a/include/linux/mmc/sdhci-spear.h~viresh-has-moved
+++ a/include/linux/mmc/sdhci-spear.h
@@ -4,7 +4,7 @@
  * SDHCI declarations specific to ST SPEAr platform
  *
  * Copyright (C) 2010 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN include/linux/pata_arasan_cf_data.h~viresh-has-moved include/=
linux/pata_arasan_cf_data.h
--- a/include/linux/pata_arasan_cf_data.h~viresh-has-moved
+++ a/include/linux/pata_arasan_cf_data.h
@@ -4,7 +4,7 @@
  * Arasan Compact Flash host controller platform data header file
  *
  * Copyright (C) 2011 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
_

Patches currently in -mm which might be from viresh.linux@gmail.com are

origin.patch
linux-next.patch
drivers-rtc-rtc-spearc-fix-use-after-free-in-spear_rtc_remove.patch
clk-add-non-config_have_clk-routines.patch
clk-remove-redundant-depends-on-from-drivers-kconfig.patch
i2c-i2c-pxa-remove-conditional-compilation-of-clk-code.patch
usb-marvell-remove-conditional-compilation-of-clk-code.patch
usb-musb-remove-conditional-compilation-of-clk-code.patch
ata-pata_arasan-remove-conditional-compilation-of-clk-code.patch
net-c_can-remove-conditional-compilation-of-clk-code.patch
net-stmmac-remove-conditional-compilation-of-clk-code.patch
gadget-m66592-remove-conditional-compilation-of-clk-code.patch
gadget-r8a66597-remove-conditional-compilation-of-clk-code.patch
usb-host-r8a66597-remove-conditional-compilation-of-clk-code.patch
clk-validate-pointer-in-__clk_disable.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
