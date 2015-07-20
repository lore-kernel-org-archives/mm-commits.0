From: akpm@linux-foundation.org
Subject: [merged] trivial-update-vireshs-email-address.patch removed from
 -mm tree
Date: Mon, 20 Jul 2015 11:50:14 -0700
Message-ID: <55ad42e6.Ob5btR9pH+cOe2Ub%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34504 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbbGTSuP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Jul 2015 14:50:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viresh.kumar@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Update Viresh Kumar's email address
has been removed from the -mm tree.  Its filename was
     trivial-update-vireshs-email-address.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Viresh Kumar <viresh.kumar@linaro.org>
Subject: Update Viresh Kumar's email address

Switch to my kernel.org alias instead of a badly named gmail address,
which I rarely use.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap                                      |    4 +++-
 Documentation/arm/SPEAr/overview.txt          |    2 +-
 MAINTAINERS                                   |   12 ++++++------
 arch/arm/boot/dts/spear1310-evb.dts           |    2 +-
 arch/arm/boot/dts/spear1310.dtsi              |    2 +-
 arch/arm/boot/dts/spear1340-evb.dts           |    2 +-
 arch/arm/boot/dts/spear1340.dtsi              |    2 +-
 arch/arm/boot/dts/spear13xx.dtsi              |    2 +-
 arch/arm/boot/dts/spear300-evb.dts            |    2 +-
 arch/arm/boot/dts/spear300.dtsi               |    2 +-
 arch/arm/boot/dts/spear310-evb.dts            |    2 +-
 arch/arm/boot/dts/spear310.dtsi               |    2 +-
 arch/arm/boot/dts/spear320-evb.dts            |    2 +-
 arch/arm/boot/dts/spear320.dtsi               |    2 +-
 arch/arm/boot/dts/spear3xx.dtsi               |    2 +-
 arch/arm/mach-spear/generic.h                 |    2 +-
 arch/arm/mach-spear/include/mach/irqs.h       |    2 +-
 arch/arm/mach-spear/include/mach/misc_regs.h  |    2 +-
 arch/arm/mach-spear/include/mach/spear.h      |    2 +-
 arch/arm/mach-spear/include/mach/uncompress.h |    2 +-
 arch/arm/mach-spear/pl080.c                   |    2 +-
 arch/arm/mach-spear/pl080.h                   |    2 +-
 arch/arm/mach-spear/restart.c                 |    2 +-
 arch/arm/mach-spear/spear1310.c               |    2 +-
 arch/arm/mach-spear/spear1340.c               |    2 +-
 arch/arm/mach-spear/spear13xx.c               |    2 +-
 arch/arm/mach-spear/spear300.c                |    2 +-
 arch/arm/mach-spear/spear310.c                |    2 +-
 arch/arm/mach-spear/spear320.c                |    2 +-
 arch/arm/mach-spear/spear3xx.c                |    2 +-
 drivers/ata/pata_arasan_cf.c                  |    4 ++--
 drivers/clk/spear/clk-aux-synth.c             |    2 +-
 drivers/clk/spear/clk-frac-synth.c            |    2 +-
 drivers/clk/spear/clk-gpt-synth.c             |    2 +-
 drivers/clk/spear/clk-vco-pll.c               |    2 +-
 drivers/clk/spear/clk.c                       |    2 +-
 drivers/clk/spear/clk.h                       |    2 +-
 drivers/clk/spear/spear1310_clock.c           |    2 +-
 drivers/clk/spear/spear1340_clock.c           |    2 +-
 drivers/clk/spear/spear3xx_clock.c            |    2 +-
 drivers/clk/spear/spear6xx_clock.c            |    2 +-
 drivers/dma/dw/core.c                         |    2 +-
 drivers/irqchip/spear-shirq.c                 |    2 +-
 drivers/mfd/stmpe-i2c.c                       |    2 +-
 drivers/mfd/stmpe-spi.c                       |    4 ++--
 drivers/mmc/host/sdhci-spear.c                |    4 ++--
 drivers/pinctrl/spear/pinctrl-spear.c         |    2 +-
 drivers/pinctrl/spear/pinctrl-spear.h         |    2 +-
 drivers/pinctrl/spear/pinctrl-spear1310.c     |    4 ++--
 drivers/pinctrl/spear/pinctrl-spear1340.c     |    4 ++--
 drivers/pinctrl/spear/pinctrl-spear300.c      |    4 ++--
 drivers/pinctrl/spear/pinctrl-spear310.c      |    4 ++--
 drivers/pinctrl/spear/pinctrl-spear320.c      |    4 ++--
 drivers/pinctrl/spear/pinctrl-spear3xx.c      |    2 +-
 drivers/pinctrl/spear/pinctrl-spear3xx.h      |    2 +-
 drivers/watchdog/sp805_wdt.c                  |    4 ++--
 include/linux/amba/sp810.h                    |    2 +-
 include/linux/pata_arasan_cf_data.h           |    2 +-
 58 files changed, 74 insertions(+), 72 deletions(-)

diff -puN .mailmap~trivial-update-vireshs-email-address .mailmap
--- a/.mailmap~trivial-update-vireshs-email-address
+++ a/.mailmap
@@ -125,7 +125,9 @@ Uwe Kleine-K=C3=B6nig <ukleinek@informatik.u
 Uwe Kleine-K=C3=B6nig <ukl@pengutronix.de>
 Uwe Kleine-K=C3=B6nig <Uwe.Kleine-Koenig@digi.com>
 Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
-Viresh Kumar <viresh.linux@gmail.com> <viresh.kumar@st.com>
+Viresh Kumar <vireshk@kernel.org> <viresh.kumar@st.com>
+Viresh Kumar <vireshk@kernel.org> <viresh.linux@gmail.com>
+Viresh Kumar <vireshk@kernel.org> <viresh.kumar2@arm.com>
 Takashi YOSHII <takashi.yoshii.zj@renesas.com>
 Yusuke Goda <goda.yusuke@renesas.com>
 Gustavo Padovan <gustavo@las.ic.unicamp.br>
diff -puN Documentation/arm/SPEAr/overview.txt~trivial-update-vireshs-e=
mail-address Documentation/arm/SPEAr/overview.txt
--- a/Documentation/arm/SPEAr/overview.txt~trivial-update-vireshs-email=
-address
+++ a/Documentation/arm/SPEAr/overview.txt
@@ -60,4 +60,4 @@ Introduction
   Document Author
   ---------------
=20
-  Viresh Kumar <viresh.linux@gmail.com>, (c) 2010-2012 ST Microelectro=
nics
+  Viresh Kumar <vireshk@kernel.org>, (c) 2010-2012 ST Microelectronics
diff -puN MAINTAINERS~trivial-update-vireshs-email-address MAINTAINERS
--- a/MAINTAINERS~trivial-update-vireshs-email-address
+++ a/MAINTAINERS
@@ -6090,7 +6090,7 @@ F:	include/linux/ata.h
 F:	include/linux/libata.h
=20
 LIBATA PATA ARASAN COMPACT FLASH CONTROLLER
-M:	Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <vireshk@kernel.org>
 L:	linux-ide@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git
 S:	Maintained
@@ -7996,7 +7996,7 @@ S:	Maintained
 F:	drivers/pinctrl/samsung/
=20
 PIN CONTROLLER - ST SPEAR
-M:	Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <vireshk@kernel.org>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers=
)
 W:	http://www.st.com/spear
@@ -8895,7 +8895,7 @@ S:	Maintained
 F:	drivers/tty/serial/
=20
 SYNOPSYS DESIGNWARE DMAC DRIVER
-M:	Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <vireshk@kernel.org>
 M:	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
 S:	Maintained
 F:	include/linux/dma/dw.h
@@ -9062,7 +9062,7 @@ S:	Maintained
 F:	drivers/mmc/host/sdhci-s3c*
=20
 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) ST SPEAR DRIVER
-M:	Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <vireshk@kernel.org>
 L:	spear-devel@list.st.com
 L:	linux-mmc@vger.kernel.org
 S:	Maintained
@@ -9600,7 +9600,7 @@ S:	Maintained
 F:	include/linux/compiler.h
=20
 SPEAR PLATFORM SUPPORT
-M:	Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <vireshk@kernel.org>
 M:	Shiraz Hashim <shiraz.linux.kernel@gmail.com>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers=
)
@@ -9609,7 +9609,7 @@ S:	Maintained
 F:	arch/arm/mach-spear/
=20
 SPEAR CLOCK FRAMEWORK SUPPORT
-M:	Viresh Kumar <viresh.linux@gmail.com>
+M:	Viresh Kumar <vireshk@kernel.org>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers=
)
 W:	http://www.st.com/spear
diff -puN arch/arm/boot/dts/spear1310-evb.dts~trivial-update-vireshs-em=
ail-address arch/arm/boot/dts/spear1310-evb.dts
--- a/arch/arm/boot/dts/spear1310-evb.dts~trivial-update-vireshs-email-=
address
+++ a/arch/arm/boot/dts/spear1310-evb.dts
@@ -1,7 +1,7 @@
 /*
  * DTS file for SPEAr1310 Evaluation Baord
  *
- * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
+ * Copyright 2012 Viresh Kumar <vireshk@kernel.org>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff -puN arch/arm/boot/dts/spear1310.dtsi~trivial-update-vireshs-email=
-address arch/arm/boot/dts/spear1310.dtsi
--- a/arch/arm/boot/dts/spear1310.dtsi~trivial-update-vireshs-email-add=
ress
+++ a/arch/arm/boot/dts/spear1310.dtsi
@@ -1,7 +1,7 @@
 /*
  * DTS file for all SPEAr1310 SoCs
  *
- * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
+ * Copyright 2012 Viresh Kumar <vireshk@kernel.org>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff -puN arch/arm/boot/dts/spear1340-evb.dts~trivial-update-vireshs-em=
ail-address arch/arm/boot/dts/spear1340-evb.dts
--- a/arch/arm/boot/dts/spear1340-evb.dts~trivial-update-vireshs-email-=
address
+++ a/arch/arm/boot/dts/spear1340-evb.dts
@@ -1,7 +1,7 @@
 /*
  * DTS file for SPEAr1340 Evaluation Baord
  *
- * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
+ * Copyright 2012 Viresh Kumar <vireshk@kernel.org>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff -puN arch/arm/boot/dts/spear1340.dtsi~trivial-update-vireshs-email=
-address arch/arm/boot/dts/spear1340.dtsi
--- a/arch/arm/boot/dts/spear1340.dtsi~trivial-update-vireshs-email-add=
ress
+++ a/arch/arm/boot/dts/spear1340.dtsi
@@ -1,7 +1,7 @@
 /*
  * DTS file for all SPEAr1340 SoCs
  *
- * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
+ * Copyright 2012 Viresh Kumar <vireshk@kernel.org>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff -puN arch/arm/boot/dts/spear13xx.dtsi~trivial-update-vireshs-email=
-address arch/arm/boot/dts/spear13xx.dtsi
--- a/arch/arm/boot/dts/spear13xx.dtsi~trivial-update-vireshs-email-add=
ress
+++ a/arch/arm/boot/dts/spear13xx.dtsi
@@ -1,7 +1,7 @@
 /*
  * DTS file for all SPEAr13xx SoCs
  *
- * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
+ * Copyright 2012 Viresh Kumar <vireshk@kernel.org>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff -puN arch/arm/boot/dts/spear300-evb.dts~trivial-update-vireshs-ema=
il-address arch/arm/boot/dts/spear300-evb.dts
--- a/arch/arm/boot/dts/spear300-evb.dts~trivial-update-vireshs-email-a=
ddress
+++ a/arch/arm/boot/dts/spear300-evb.dts
@@ -1,7 +1,7 @@
 /*
  * DTS file for SPEAr300 Evaluation Baord
  *
- * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
+ * Copyright 2012 Viresh Kumar <vireshk@kernel.org>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff -puN arch/arm/boot/dts/spear300.dtsi~trivial-update-vireshs-email-=
address arch/arm/boot/dts/spear300.dtsi
--- a/arch/arm/boot/dts/spear300.dtsi~trivial-update-vireshs-email-addr=
ess
+++ a/arch/arm/boot/dts/spear300.dtsi
@@ -1,7 +1,7 @@
 /*
  * DTS file for SPEAr300 SoC
  *
- * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
+ * Copyright 2012 Viresh Kumar <vireshk@kernel.org>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff -puN arch/arm/boot/dts/spear310-evb.dts~trivial-update-vireshs-ema=
il-address arch/arm/boot/dts/spear310-evb.dts
--- a/arch/arm/boot/dts/spear310-evb.dts~trivial-update-vireshs-email-a=
ddress
+++ a/arch/arm/boot/dts/spear310-evb.dts
@@ -1,7 +1,7 @@
 /*
  * DTS file for SPEAr310 Evaluation Baord
  *
- * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
+ * Copyright 2012 Viresh Kumar <vireshk@kernel.org>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff -puN arch/arm/boot/dts/spear310.dtsi~trivial-update-vireshs-email-=
address arch/arm/boot/dts/spear310.dtsi
--- a/arch/arm/boot/dts/spear310.dtsi~trivial-update-vireshs-email-addr=
ess
+++ a/arch/arm/boot/dts/spear310.dtsi
@@ -1,7 +1,7 @@
 /*
  * DTS file for SPEAr310 SoC
  *
- * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
+ * Copyright 2012 Viresh Kumar <vireshk@kernel.org>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff -puN arch/arm/boot/dts/spear320-evb.dts~trivial-update-vireshs-ema=
il-address arch/arm/boot/dts/spear320-evb.dts
--- a/arch/arm/boot/dts/spear320-evb.dts~trivial-update-vireshs-email-a=
ddress
+++ a/arch/arm/boot/dts/spear320-evb.dts
@@ -1,7 +1,7 @@
 /*
  * DTS file for SPEAr320 Evaluation Baord
  *
- * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
+ * Copyright 2012 Viresh Kumar <vireshk@kernel.org>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff -puN arch/arm/boot/dts/spear320.dtsi~trivial-update-vireshs-email-=
address arch/arm/boot/dts/spear320.dtsi
--- a/arch/arm/boot/dts/spear320.dtsi~trivial-update-vireshs-email-addr=
ess
+++ a/arch/arm/boot/dts/spear320.dtsi
@@ -1,7 +1,7 @@
 /*
  * DTS file for SPEAr320 SoC
  *
- * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
+ * Copyright 2012 Viresh Kumar <vireshk@kernel.org>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff -puN arch/arm/boot/dts/spear3xx.dtsi~trivial-update-vireshs-email-=
address arch/arm/boot/dts/spear3xx.dtsi
--- a/arch/arm/boot/dts/spear3xx.dtsi~trivial-update-vireshs-email-addr=
ess
+++ a/arch/arm/boot/dts/spear3xx.dtsi
@@ -1,7 +1,7 @@
 /*
  * DTS file for all SPEAr3xx SoCs
  *
- * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
+ * Copyright 2012 Viresh Kumar <vireshk@kernel.org>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff -puN arch/arm/mach-spear/generic.h~trivial-update-vireshs-email-ad=
dress arch/arm/mach-spear/generic.h
--- a/arch/arm/mach-spear/generic.h~trivial-update-vireshs-email-addres=
s
+++ a/arch/arm/mach-spear/generic.h
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2009-2012 ST Microelectronics
  * Rajeev Kumar <rajeev-dlh.kumar@st.com>
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear/include/mach/irqs.h~trivial-update-viresh=
s-email-address arch/arm/mach-spear/include/mach/irqs.h
--- a/arch/arm/mach-spear/include/mach/irqs.h~trivial-update-vireshs-em=
ail-address
+++ a/arch/arm/mach-spear/include/mach/irqs.h
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2009-2012 ST Microelectronics
  * Rajeev Kumar <rajeev-dlh.kumar@st.com>
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear/include/mach/misc_regs.h~trivial-update-v=
ireshs-email-address arch/arm/mach-spear/include/mach/misc_regs.h
--- a/arch/arm/mach-spear/include/mach/misc_regs.h~trivial-update-vires=
hs-email-address
+++ a/arch/arm/mach-spear/include/mach/misc_regs.h
@@ -4,7 +4,7 @@
  * Miscellaneous registers definitions for SPEAr3xx machine family
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear/include/mach/spear.h~trivial-update-vires=
hs-email-address arch/arm/mach-spear/include/mach/spear.h
--- a/arch/arm/mach-spear/include/mach/spear.h~trivial-update-vireshs-e=
mail-address
+++ a/arch/arm/mach-spear/include/mach/spear.h
@@ -3,7 +3,7 @@
  *
  * Copyright (C) 2009,2012 ST Microelectronics
  * Rajeev Kumar<rajeev-dlh.kumar@st.com>
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear/include/mach/uncompress.h~trivial-update-=
vireshs-email-address arch/arm/mach-spear/include/mach/uncompress.h
--- a/arch/arm/mach-spear/include/mach/uncompress.h~trivial-update-vire=
shs-email-address
+++ a/arch/arm/mach-spear/include/mach/uncompress.h
@@ -4,7 +4,7 @@
  * Serial port stubs for kernel decompress status messages
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear/pl080.c~trivial-update-vireshs-email-addr=
ess arch/arm/mach-spear/pl080.c
--- a/arch/arm/mach-spear/pl080.c~trivial-update-vireshs-email-address
+++ a/arch/arm/mach-spear/pl080.c
@@ -4,7 +4,7 @@
  * DMAC pl080 definitions for SPEAr platform
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear/pl080.h~trivial-update-vireshs-email-addr=
ess arch/arm/mach-spear/pl080.h
--- a/arch/arm/mach-spear/pl080.h~trivial-update-vireshs-email-address
+++ a/arch/arm/mach-spear/pl080.h
@@ -4,7 +4,7 @@
  * DMAC pl080 definitions for SPEAr platform
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear/restart.c~trivial-update-vireshs-email-ad=
dress arch/arm/mach-spear/restart.c
--- a/arch/arm/mach-spear/restart.c~trivial-update-vireshs-email-addres=
s
+++ a/arch/arm/mach-spear/restart.c
@@ -4,7 +4,7 @@
  * SPEAr platform specific restart functions
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear/spear1310.c~trivial-update-vireshs-email-=
address arch/arm/mach-spear/spear1310.c
--- a/arch/arm/mach-spear/spear1310.c~trivial-update-vireshs-email-addr=
ess
+++ a/arch/arm/mach-spear/spear1310.c
@@ -4,7 +4,7 @@
  * SPEAr1310 machine source file
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear/spear1340.c~trivial-update-vireshs-email-=
address arch/arm/mach-spear/spear1340.c
--- a/arch/arm/mach-spear/spear1340.c~trivial-update-vireshs-email-addr=
ess
+++ a/arch/arm/mach-spear/spear1340.c
@@ -4,7 +4,7 @@
  * SPEAr1340 machine source file
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear/spear13xx.c~trivial-update-vireshs-email-=
address arch/arm/mach-spear/spear13xx.c
--- a/arch/arm/mach-spear/spear13xx.c~trivial-update-vireshs-email-addr=
ess
+++ a/arch/arm/mach-spear/spear13xx.c
@@ -4,7 +4,7 @@
  * SPEAr13XX machines common source file
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear/spear300.c~trivial-update-vireshs-email-a=
ddress arch/arm/mach-spear/spear300.c
--- a/arch/arm/mach-spear/spear300.c~trivial-update-vireshs-email-addre=
ss
+++ a/arch/arm/mach-spear/spear300.c
@@ -4,7 +4,7 @@
  * SPEAr300 machine source file
  *
  * Copyright (C) 2009-2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear/spear310.c~trivial-update-vireshs-email-a=
ddress arch/arm/mach-spear/spear310.c
--- a/arch/arm/mach-spear/spear310.c~trivial-update-vireshs-email-addre=
ss
+++ a/arch/arm/mach-spear/spear310.c
@@ -4,7 +4,7 @@
  * SPEAr310 machine source file
  *
  * Copyright (C) 2009-2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear/spear320.c~trivial-update-vireshs-email-a=
ddress arch/arm/mach-spear/spear320.c
--- a/arch/arm/mach-spear/spear320.c~trivial-update-vireshs-email-addre=
ss
+++ a/arch/arm/mach-spear/spear320.c
@@ -4,7 +4,7 @@
  * SPEAr320 machine source file
  *
  * Copyright (C) 2009-2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN arch/arm/mach-spear/spear3xx.c~trivial-update-vireshs-email-a=
ddress arch/arm/mach-spear/spear3xx.c
--- a/arch/arm/mach-spear/spear3xx.c~trivial-update-vireshs-email-addre=
ss
+++ a/arch/arm/mach-spear/spear3xx.c
@@ -4,7 +4,7 @@
  * SPEAr3XX machines common source file
  *
  * Copyright (C) 2009-2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/ata/pata_arasan_cf.c~trivial-update-vireshs-email-add=
ress drivers/ata/pata_arasan_cf.c
--- a/drivers/ata/pata_arasan_cf.c~trivial-update-vireshs-email-address
+++ a/drivers/ata/pata_arasan_cf.c
@@ -4,7 +4,7 @@
  * Arasan Compact Flash host controller source file
  *
  * Copyright (C) 2011 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
@@ -968,7 +968,7 @@ static struct platform_driver arasan_cf_
=20
 module_platform_driver(arasan_cf_driver);
=20
-MODULE_AUTHOR("Viresh Kumar <viresh.linux@gmail.com>");
+MODULE_AUTHOR("Viresh Kumar <vireshk@kernel.org>");
 MODULE_DESCRIPTION("Arasan ATA Compact Flash driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:" DRIVER_NAME);
diff -puN drivers/clk/spear/clk-aux-synth.c~trivial-update-vireshs-emai=
l-address drivers/clk/spear/clk-aux-synth.c
--- a/drivers/clk/spear/clk-aux-synth.c~trivial-update-vireshs-email-ad=
dress
+++ a/drivers/clk/spear/clk-aux-synth.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/clk/spear/clk-frac-synth.c~trivial-update-vireshs-ema=
il-address drivers/clk/spear/clk-frac-synth.c
--- a/drivers/clk/spear/clk-frac-synth.c~trivial-update-vireshs-email-a=
ddress
+++ a/drivers/clk/spear/clk-frac-synth.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/clk/spear/clk-gpt-synth.c~trivial-update-vireshs-emai=
l-address drivers/clk/spear/clk-gpt-synth.c
--- a/drivers/clk/spear/clk-gpt-synth.c~trivial-update-vireshs-email-ad=
dress
+++ a/drivers/clk/spear/clk-gpt-synth.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/clk/spear/clk-vco-pll.c~trivial-update-vireshs-email-=
address drivers/clk/spear/clk-vco-pll.c
--- a/drivers/clk/spear/clk-vco-pll.c~trivial-update-vireshs-email-addr=
ess
+++ a/drivers/clk/spear/clk-vco-pll.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/clk/spear/clk.c~trivial-update-vireshs-email-address =
drivers/clk/spear/clk.c
--- a/drivers/clk/spear/clk.c~trivial-update-vireshs-email-address
+++ a/drivers/clk/spear/clk.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/clk/spear/clk.h~trivial-update-vireshs-email-address =
drivers/clk/spear/clk.h
--- a/drivers/clk/spear/clk.h~trivial-update-vireshs-email-address
+++ a/drivers/clk/spear/clk.h
@@ -2,7 +2,7 @@
  * Clock framework definitions for SPEAr platform
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/clk/spear/spear1310_clock.c~trivial-update-vireshs-em=
ail-address drivers/clk/spear/spear1310_clock.c
--- a/drivers/clk/spear/spear1310_clock.c~trivial-update-vireshs-email-=
address
+++ a/drivers/clk/spear/spear1310_clock.c
@@ -4,7 +4,7 @@
  * SPEAr1310 machine clock framework source file
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/clk/spear/spear1340_clock.c~trivial-update-vireshs-em=
ail-address drivers/clk/spear/spear1340_clock.c
--- a/drivers/clk/spear/spear1340_clock.c~trivial-update-vireshs-email-=
address
+++ a/drivers/clk/spear/spear1340_clock.c
@@ -4,7 +4,7 @@
  * SPEAr1340 machine clock framework source file
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/clk/spear/spear3xx_clock.c~trivial-update-vireshs-ema=
il-address drivers/clk/spear/spear3xx_clock.c
--- a/drivers/clk/spear/spear3xx_clock.c~trivial-update-vireshs-email-a=
ddress
+++ a/drivers/clk/spear/spear3xx_clock.c
@@ -2,7 +2,7 @@
  * SPEAr3xx machines clock framework source file
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/clk/spear/spear6xx_clock.c~trivial-update-vireshs-ema=
il-address drivers/clk/spear/spear6xx_clock.c
--- a/drivers/clk/spear/spear6xx_clock.c~trivial-update-vireshs-email-a=
ddress
+++ a/drivers/clk/spear/spear6xx_clock.c
@@ -2,7 +2,7 @@
  * SPEAr6xx machines clock framework source file
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/dma/dw/core.c~trivial-update-vireshs-email-address dr=
ivers/dma/dw/core.c
--- a/drivers/dma/dw/core.c~trivial-update-vireshs-email-address
+++ a/drivers/dma/dw/core.c
@@ -1746,4 +1746,4 @@ EXPORT_SYMBOL_GPL(dw_dma_enable);
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Synopsys DesignWare DMA Controller core driver");
 MODULE_AUTHOR("Haavard Skinnemoen (Atmel)");
-MODULE_AUTHOR("Viresh Kumar <viresh.linux@gmail.com>");
+MODULE_AUTHOR("Viresh Kumar <vireshk@kernel.org>");
diff -puN drivers/irqchip/spear-shirq.c~trivial-update-vireshs-email-ad=
dress drivers/irqchip/spear-shirq.c
--- a/drivers/irqchip/spear-shirq.c~trivial-update-vireshs-email-addres=
s
+++ a/drivers/irqchip/spear-shirq.c
@@ -2,7 +2,7 @@
  * SPEAr platform shared irq layer source file
  *
  * Copyright (C) 2009-2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * Copyright (C) 2012 ST Microelectronics
  * Shiraz Hashim <shiraz.linux.kernel@gmail.com>
diff -puN drivers/mfd/stmpe-i2c.c~trivial-update-vireshs-email-address =
drivers/mfd/stmpe-i2c.c
--- a/drivers/mfd/stmpe-i2c.c~trivial-update-vireshs-email-address
+++ a/drivers/mfd/stmpe-i2c.c
@@ -6,7 +6,7 @@
  *
  * License Terms: GNU General Public License, version 2
  * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsso=
n
- * Author: Viresh Kumar <viresh.linux@gmail.com> for ST Microelectroni=
cs
+ * Author: Viresh Kumar <vireshk@kernel.org> for ST Microelectronics
  */
=20
 #include <linux/i2c.h>
diff -puN drivers/mfd/stmpe-spi.c~trivial-update-vireshs-email-address =
drivers/mfd/stmpe-spi.c
--- a/drivers/mfd/stmpe-spi.c~trivial-update-vireshs-email-address
+++ a/drivers/mfd/stmpe-spi.c
@@ -4,7 +4,7 @@
  * Copyright (C) ST Microelectronics SA 2011
  *
  * License Terms: GNU General Public License, version 2
- * Author: Viresh Kumar <viresh.linux@gmail.com> for ST Microelectroni=
cs
+ * Author: Viresh Kumar <vireshk@kernel.org> for ST Microelectronics
  */
=20
 #include <linux/spi/spi.h>
@@ -146,4 +146,4 @@ module_exit(stmpe_exit);
=20
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("STMPE MFD SPI Interface Driver");
-MODULE_AUTHOR("Viresh Kumar <viresh.linux@gmail.com>");
+MODULE_AUTHOR("Viresh Kumar <vireshk@kernel.org>");
diff -puN drivers/mmc/host/sdhci-spear.c~trivial-update-vireshs-email-a=
ddress drivers/mmc/host/sdhci-spear.c
--- a/drivers/mmc/host/sdhci-spear.c~trivial-update-vireshs-email-addre=
ss
+++ a/drivers/mmc/host/sdhci-spear.c
@@ -4,7 +4,7 @@
  * Support of SDHCI platform devices for spear soc family
  *
  * Copyright (C) 2010 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * Inspired by sdhci-pltfm.c
  *
@@ -211,5 +211,5 @@ static struct platform_driver sdhci_driv
 module_platform_driver(sdhci_driver);
=20
 MODULE_DESCRIPTION("SPEAr Secure Digital Host Controller Interface dri=
ver");
-MODULE_AUTHOR("Viresh Kumar <viresh.linux@gmail.com>");
+MODULE_AUTHOR("Viresh Kumar <vireshk@kernel.org>");
 MODULE_LICENSE("GPL v2");
diff -puN drivers/pinctrl/spear/pinctrl-spear.c~trivial-update-vireshs-=
email-address drivers/pinctrl/spear/pinctrl-spear.c
--- a/drivers/pinctrl/spear/pinctrl-spear.c~trivial-update-vireshs-emai=
l-address
+++ a/drivers/pinctrl/spear/pinctrl-spear.c
@@ -2,7 +2,7 @@
  * Driver for the ST Microelectronics SPEAr pinmux
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * Inspired from:
  * - U300 Pinctl drivers
diff -puN drivers/pinctrl/spear/pinctrl-spear.h~trivial-update-vireshs-=
email-address drivers/pinctrl/spear/pinctrl-spear.h
--- a/drivers/pinctrl/spear/pinctrl-spear.h~trivial-update-vireshs-emai=
l-address
+++ a/drivers/pinctrl/spear/pinctrl-spear.h
@@ -2,7 +2,7 @@
  * Driver header file for the ST Microelectronics SPEAr pinmux
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/pinctrl/spear/pinctrl-spear1310.c~trivial-update-vire=
shs-email-address drivers/pinctrl/spear/pinctrl-spear1310.c
--- a/drivers/pinctrl/spear/pinctrl-spear1310.c~trivial-update-vireshs-=
email-address
+++ a/drivers/pinctrl/spear/pinctrl-spear1310.c
@@ -2,7 +2,7 @@
  * Driver for the ST Microelectronics SPEAr1310 pinmux
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
@@ -2730,7 +2730,7 @@ static void __exit spear1310_pinctrl_exi
 }
 module_exit(spear1310_pinctrl_exit);
=20
-MODULE_AUTHOR("Viresh Kumar <viresh.linux@gmail.com>");
+MODULE_AUTHOR("Viresh Kumar <vireshk@kernel.org>");
 MODULE_DESCRIPTION("ST Microelectronics SPEAr1310 pinctrl driver");
 MODULE_LICENSE("GPL v2");
 MODULE_DEVICE_TABLE(of, spear1310_pinctrl_of_match);
diff -puN drivers/pinctrl/spear/pinctrl-spear1340.c~trivial-update-vire=
shs-email-address drivers/pinctrl/spear/pinctrl-spear1340.c
--- a/drivers/pinctrl/spear/pinctrl-spear1340.c~trivial-update-vireshs-=
email-address
+++ a/drivers/pinctrl/spear/pinctrl-spear1340.c
@@ -2,7 +2,7 @@
  * Driver for the ST Microelectronics SPEAr1340 pinmux
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
@@ -2046,7 +2046,7 @@ static void __exit spear1340_pinctrl_exi
 }
 module_exit(spear1340_pinctrl_exit);
=20
-MODULE_AUTHOR("Viresh Kumar <viresh.linux@gmail.com>");
+MODULE_AUTHOR("Viresh Kumar <vireshk@kernel.org>");
 MODULE_DESCRIPTION("ST Microelectronics SPEAr1340 pinctrl driver");
 MODULE_LICENSE("GPL v2");
 MODULE_DEVICE_TABLE(of, spear1340_pinctrl_of_match);
diff -puN drivers/pinctrl/spear/pinctrl-spear300.c~trivial-update-vires=
hs-email-address drivers/pinctrl/spear/pinctrl-spear300.c
--- a/drivers/pinctrl/spear/pinctrl-spear300.c~trivial-update-vireshs-e=
mail-address
+++ a/drivers/pinctrl/spear/pinctrl-spear300.c
@@ -2,7 +2,7 @@
  * Driver for the ST Microelectronics SPEAr300 pinmux
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
@@ -703,7 +703,7 @@ static void __exit spear300_pinctrl_exit
 }
 module_exit(spear300_pinctrl_exit);
=20
-MODULE_AUTHOR("Viresh Kumar <viresh.linux@gmail.com>");
+MODULE_AUTHOR("Viresh Kumar <vireshk@kernel.org>");
 MODULE_DESCRIPTION("ST Microelectronics SPEAr300 pinctrl driver");
 MODULE_LICENSE("GPL v2");
 MODULE_DEVICE_TABLE(of, spear300_pinctrl_of_match);
diff -puN drivers/pinctrl/spear/pinctrl-spear310.c~trivial-update-vires=
hs-email-address drivers/pinctrl/spear/pinctrl-spear310.c
--- a/drivers/pinctrl/spear/pinctrl-spear310.c~trivial-update-vireshs-e=
mail-address
+++ a/drivers/pinctrl/spear/pinctrl-spear310.c
@@ -2,7 +2,7 @@
  * Driver for the ST Microelectronics SPEAr310 pinmux
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
@@ -426,7 +426,7 @@ static void __exit spear310_pinctrl_exit
 }
 module_exit(spear310_pinctrl_exit);
=20
-MODULE_AUTHOR("Viresh Kumar <viresh.linux@gmail.com>");
+MODULE_AUTHOR("Viresh Kumar <vireshk@kernel.org>");
 MODULE_DESCRIPTION("ST Microelectronics SPEAr310 pinctrl driver");
 MODULE_LICENSE("GPL v2");
 MODULE_DEVICE_TABLE(of, spear310_pinctrl_of_match);
diff -puN drivers/pinctrl/spear/pinctrl-spear320.c~trivial-update-vires=
hs-email-address drivers/pinctrl/spear/pinctrl-spear320.c
--- a/drivers/pinctrl/spear/pinctrl-spear320.c~trivial-update-vireshs-e=
mail-address
+++ a/drivers/pinctrl/spear/pinctrl-spear320.c
@@ -2,7 +2,7 @@
  * Driver for the ST Microelectronics SPEAr320 pinmux
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
@@ -3467,7 +3467,7 @@ static void __exit spear320_pinctrl_exit
 }
 module_exit(spear320_pinctrl_exit);
=20
-MODULE_AUTHOR("Viresh Kumar <viresh.linux@gmail.com>");
+MODULE_AUTHOR("Viresh Kumar <vireshk@kernel.org>");
 MODULE_DESCRIPTION("ST Microelectronics SPEAr320 pinctrl driver");
 MODULE_LICENSE("GPL v2");
 MODULE_DEVICE_TABLE(of, spear320_pinctrl_of_match);
diff -puN drivers/pinctrl/spear/pinctrl-spear3xx.c~trivial-update-vires=
hs-email-address drivers/pinctrl/spear/pinctrl-spear3xx.c
--- a/drivers/pinctrl/spear/pinctrl-spear3xx.c~trivial-update-vireshs-e=
mail-address
+++ a/drivers/pinctrl/spear/pinctrl-spear3xx.c
@@ -2,7 +2,7 @@
  * Driver for the ST Microelectronics SPEAr3xx pinmux
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/pinctrl/spear/pinctrl-spear3xx.h~trivial-update-vires=
hs-email-address drivers/pinctrl/spear/pinctrl-spear3xx.h
--- a/drivers/pinctrl/spear/pinctrl-spear3xx.h~trivial-update-vireshs-e=
mail-address
+++ a/drivers/pinctrl/spear/pinctrl-spear3xx.h
@@ -2,7 +2,7 @@
  * Header file for the ST Microelectronics SPEAr3xx pinmux
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/watchdog/sp805_wdt.c~trivial-update-vireshs-email-add=
ress drivers/watchdog/sp805_wdt.c
--- a/drivers/watchdog/sp805_wdt.c~trivial-update-vireshs-email-address
+++ a/drivers/watchdog/sp805_wdt.c
@@ -4,7 +4,7 @@
  * Watchdog driver for ARM SP805 watchdog module
  *
  * Copyright (C) 2010 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2 or later. This program is licensed "as is" withou=
t any
@@ -303,6 +303,6 @@ static struct amba_driver sp805_wdt_driv
=20
 module_amba_driver(sp805_wdt_driver);
=20
-MODULE_AUTHOR("Viresh Kumar <viresh.linux@gmail.com>");
+MODULE_AUTHOR("Viresh Kumar <vireshk@kernel.org>");
 MODULE_DESCRIPTION("ARM SP805 Watchdog Driver");
 MODULE_LICENSE("GPL");
diff -puN include/linux/amba/sp810.h~trivial-update-vireshs-email-addre=
ss include/linux/amba/sp810.h
--- a/include/linux/amba/sp810.h~trivial-update-vireshs-email-address
+++ a/include/linux/amba/sp810.h
@@ -2,7 +2,7 @@
  * ARM PrimeXsys System Controller SP810 header file
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN include/linux/pata_arasan_cf_data.h~trivial-update-vireshs-em=
ail-address include/linux/pata_arasan_cf_data.h
--- a/include/linux/pata_arasan_cf_data.h~trivial-update-vireshs-email-=
address
+++ a/include/linux/pata_arasan_cf_data.h
@@ -4,7 +4,7 @@
  * Arasan Compact Flash host controller platform data header file
  *
  * Copyright (C) 2011 ST Microelectronics
- * Viresh Kumar <viresh.linux@gmail.com>
+ * Viresh Kumar <vireshk@kernel.org>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
_

Patches currently in -mm which might be from viresh.kumar@linaro.org ar=
e

linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
