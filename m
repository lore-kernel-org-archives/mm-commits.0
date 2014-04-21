From: akpm@linux-foundation.org
Subject: [merged] shiraz-has-moved.patch removed from -mm tree
Date: Mon, 21 Apr 2014 11:11:01 -0700
Message-ID: <53555f35.btABgS840xlea7Gi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35648 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbaDUSLC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 14:11:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shiraz.linux.kernel@gmail.com, viresh.kumar@linaro.org

Subject: [merged] shiraz-has-moved.patch removed from -mm tree
To: viresh.kumar@linaro.org,shiraz.linux.kernel@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 11:11:01 -0700


The patch titled
     Subject: Shiraz has moved
has been removed from the -mm tree.  Its filename was
     shiraz-has-moved.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Viresh Kumar <viresh.kumar@linaro.org>
Subject: Shiraz has moved

shiraz.hashim@st.com email-id doesn't exist anymore as he has left the
company.  Replace ST's id with shiraz.linux.kernel@gmail.com.

It also updates .mailmap file to fix address for 'git shortlog'.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Shiraz Hashim <shiraz.linux.kernel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap                           |    1 +
 MAINTAINERS                        |    2 +-
 arch/arm/boot/dts/spear320-hmi.dts |    2 +-
 arch/arm/mach-spear/headsmp.S      |    2 +-
 arch/arm/mach-spear/platsmp.c      |    2 +-
 arch/arm/mach-spear/time.c         |    2 +-
 drivers/gpio/gpio-spear-spics.c    |    4 ++--
 drivers/irqchip/spear-shirq.c      |    2 +-
 drivers/mtd/devices/spear_smi.c    |    4 ++--
 drivers/pwm/pwm-spear.c            |    4 ++--
 include/linux/mtd/spear_smi.h      |    2 +-
 11 files changed, 14 insertions(+), 13 deletions(-)

diff -puN .mailmap~shiraz-has-moved .mailmap
--- a/.mailmap~shiraz-has-moved
+++ a/.mailmap
@@ -99,6 +99,7 @@ Sachin P Sant <ssant@in.ibm.com>
 Sam Ravnborg <sam@mars.ravnborg.org>
 Sascha Hauer <s.hauer@pengutronix.de>
 S.Çağlar Onur <caglar@pardus.org.tr>
+Shiraz Hashim <shiraz.linux.kernel@gmail.com> <shiraz.hashim@st.com>
 Simon Kelley <simon@thekelleys.org.uk>
 Stéphane Witzmann <stephane.witzmann@ubpmes.univ-bpclermont.fr>
 Stephen Hemminger <shemminger@osdl.org>
diff -puN MAINTAINERS~shiraz-has-moved MAINTAINERS
--- a/MAINTAINERS~shiraz-has-moved
+++ a/MAINTAINERS
@@ -8314,7 +8314,7 @@ F:	include/linux/compiler.h
 
 SPEAR PLATFORM SUPPORT
 M:	Viresh Kumar <viresh.linux@gmail.com>
-M:	Shiraz Hashim <shiraz.hashim@st.com>
+M:	Shiraz Hashim <shiraz.linux.kernel@gmail.com>
 L:	spear-devel@list.st.com
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:	http://www.st.com/spear
diff -puN arch/arm/boot/dts/spear320-hmi.dts~shiraz-has-moved arch/arm/boot/dts/spear320-hmi.dts
--- a/arch/arm/boot/dts/spear320-hmi.dts~shiraz-has-moved
+++ a/arch/arm/boot/dts/spear320-hmi.dts
@@ -1,7 +1,7 @@
 /*
  * DTS file for SPEAr320 Evaluation Baord
  *
- * Copyright 2012 Shiraz Hashim <shiraz.hashim@st.com>
+ * Copyright 2012 Shiraz Hashim <shiraz.linux.kernel@gmail.com>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff -puN arch/arm/mach-spear/headsmp.S~shiraz-has-moved arch/arm/mach-spear/headsmp.S
--- a/arch/arm/mach-spear/headsmp.S~shiraz-has-moved
+++ a/arch/arm/mach-spear/headsmp.S
@@ -3,7 +3,7 @@
  *
  * Picked from realview
  * Copyright (c) 2012 ST Microelectronics Limited
- * Shiraz Hashim <shiraz.hashim@st.com>
+ * Shiraz Hashim <shiraz.linux.kernel@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff -puN arch/arm/mach-spear/platsmp.c~shiraz-has-moved arch/arm/mach-spear/platsmp.c
--- a/arch/arm/mach-spear/platsmp.c~shiraz-has-moved
+++ a/arch/arm/mach-spear/platsmp.c
@@ -4,7 +4,7 @@
  * based upon linux/arch/arm/mach-realview/platsmp.c
  *
  * Copyright (C) 2012 ST Microelectronics Ltd.
- * Shiraz Hashim <shiraz.hashim@st.com>
+ * Shiraz Hashim <shiraz.linux.kernel@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff -puN arch/arm/mach-spear/time.c~shiraz-has-moved arch/arm/mach-spear/time.c
--- a/arch/arm/mach-spear/time.c~shiraz-has-moved
+++ a/arch/arm/mach-spear/time.c
@@ -2,7 +2,7 @@
  * arch/arm/plat-spear/time.c
  *
  * Copyright (C) 2010 ST Microelectronics
- * Shiraz Hashim<shiraz.hashim@st.com>
+ * Shiraz Hashim<shiraz.linux.kernel@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/gpio/gpio-spear-spics.c~shiraz-has-moved drivers/gpio/gpio-spear-spics.c
--- a/drivers/gpio/gpio-spear-spics.c~shiraz-has-moved
+++ a/drivers/gpio/gpio-spear-spics.c
@@ -2,7 +2,7 @@
  * SPEAr platform SPI chipselect abstraction over gpiolib
  *
  * Copyright (C) 2012 ST Microelectronics
- * Shiraz Hashim <shiraz.hashim@st.com>
+ * Shiraz Hashim <shiraz.linux.kernel@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
@@ -205,6 +205,6 @@ static int __init spics_gpio_init(void)
 }
 subsys_initcall(spics_gpio_init);
 
-MODULE_AUTHOR("Shiraz Hashim <shiraz.hashim@st.com>");
+MODULE_AUTHOR("Shiraz Hashim <shiraz.linux.kernel@gmail.com>");
 MODULE_DESCRIPTION("ST Microlectronics SPEAr SPI Chip Select Abstraction");
 MODULE_LICENSE("GPL");
diff -puN drivers/irqchip/spear-shirq.c~shiraz-has-moved drivers/irqchip/spear-shirq.c
--- a/drivers/irqchip/spear-shirq.c~shiraz-has-moved
+++ a/drivers/irqchip/spear-shirq.c
@@ -5,7 +5,7 @@
  * Viresh Kumar <viresh.linux@gmail.com>
  *
  * Copyright (C) 2012 ST Microelectronics
- * Shiraz Hashim <shiraz.hashim@st.com>
+ * Shiraz Hashim <shiraz.linux.kernel@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/mtd/devices/spear_smi.c~shiraz-has-moved drivers/mtd/devices/spear_smi.c
--- a/drivers/mtd/devices/spear_smi.c~shiraz-has-moved
+++ a/drivers/mtd/devices/spear_smi.c
@@ -6,7 +6,7 @@
  *
  * Copyright © 2010 STMicroelectronics.
  * Ashish Priyadarshi
- * Shiraz Hashim <shiraz.hashim@st.com>
+ * Shiraz Hashim <shiraz.linux.kernel@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
@@ -1089,5 +1089,5 @@ static struct platform_driver spear_smi_
 module_platform_driver(spear_smi_driver);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Ashish Priyadarshi, Shiraz Hashim <shiraz.hashim@st.com>");
+MODULE_AUTHOR("Ashish Priyadarshi, Shiraz Hashim <shiraz.linux.kernel@gmail.com>");
 MODULE_DESCRIPTION("MTD SMI driver for serial nor flash chips");
diff -puN drivers/pwm/pwm-spear.c~shiraz-has-moved drivers/pwm/pwm-spear.c
--- a/drivers/pwm/pwm-spear.c~shiraz-has-moved
+++ a/drivers/pwm/pwm-spear.c
@@ -2,7 +2,7 @@
  * ST Microelectronics SPEAr Pulse Width Modulator driver
  *
  * Copyright (C) 2012 ST Microelectronics
- * Shiraz Hashim <shiraz.hashim@st.com>
+ * Shiraz Hashim <shiraz.linux.kernel@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
@@ -264,6 +264,6 @@ static struct platform_driver spear_pwm_
 module_platform_driver(spear_pwm_driver);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Shiraz Hashim <shiraz.hashim@st.com>");
+MODULE_AUTHOR("Shiraz Hashim <shiraz.linux.kernel@gmail.com>");
 MODULE_AUTHOR("Viresh Kumar <viresh.kumar@linaro.com>");
 MODULE_ALIAS("platform:spear-pwm");
diff -puN include/linux/mtd/spear_smi.h~shiraz-has-moved include/linux/mtd/spear_smi.h
--- a/include/linux/mtd/spear_smi.h~shiraz-has-moved
+++ a/include/linux/mtd/spear_smi.h
@@ -1,6 +1,6 @@
 /*
  * Copyright © 2010 ST Microelectronics
- * Shiraz Hashim <shiraz.hashim@st.com>
+ * Shiraz Hashim <shiraz.linux.kernel@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
_

Patches currently in -mm which might be from viresh.kumar@linaro.org are

linux-next.patch

