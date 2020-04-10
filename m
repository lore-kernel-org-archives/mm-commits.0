From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 31/35] change email address for Pali
 =?utf-8?Q?Roh=C3=A1r?=
Date: Fri, 10 Apr 2020 14:34:00 -0700
Message-ID: <20200410213400.DMoow51CI%akpm@linux-foundation.org>
References: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbgDJVeB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 17:34:01 -0400
In-Reply-To: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org, joe@perches.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, pali@kernel.org, torvalds@linux-foundation.org

=46rom: Pali Roh=C3=A1r <pali@kernel.org>
Subject: change email address for Pali Roh=C3=A1r

For security reasons I stopped using gmail account and kernel address is
now up-to-date alias to my personal address.

People periodically send me emails to address which they found in source
code of drivers, so this change reflects state where people can contact me.

Link: http://lkml.kernel.org/r/20200307104237.8199-1-pali@kernel.org
Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-platform-dell-laptop |    8 ++---
 MAINTAINERS                                          |   16 +++++-----
 arch/arm/mach-omap2/omap-secure.c                    |    2 -
 arch/arm/mach-omap2/omap-secure.h                    |    2 -
 arch/arm/mach-omap2/omap-smc.S                       |    2 -
 drivers/char/hw_random/omap3-rom-rng.c               |    4 +-
 drivers/hwmon/dell-smm-hwmon.c                       |    4 +-
 drivers/platform/x86/dell-laptop.c                   |    4 +-
 drivers/platform/x86/dell-rbtn.c                     |    4 +-
 drivers/platform/x86/dell-rbtn.h                     |    2 -
 drivers/platform/x86/dell-smbios-base.c              |    4 +-
 drivers/platform/x86/dell-smbios-smm.c               |    2 -
 drivers/platform/x86/dell-smbios.h                   |    2 -
 drivers/platform/x86/dell-smo8800.c                  |    2 -
 drivers/platform/x86/dell-wmi.c                      |    4 +-
 drivers/power/supply/bq2415x_charger.c               |    4 +-
 drivers/power/supply/bq27xxx_battery.c               |    2 -
 drivers/power/supply/isp1704_charger.c               |    2 -
 drivers/power/supply/rx51_battery.c                  |    4 +-
 fs/udf/ecma_167.h                                    |    2 -
 fs/udf/osta_udf.h                                    |    2 -
 include/linux/power/bq2415x_charger.h                |    2 -
 tools/laptop/freefall/freefall.c                     |    2 -
 23 files changed, 41 insertions(+), 41 deletions(-)

--- a/arch/arm/mach-omap2/omap-secure.c~change-email-address-for-pali-rohar
+++ a/arch/arm/mach-omap2/omap-secure.c
@@ -5,7 +5,7 @@
  * Copyright (C) 2011 Texas Instruments, Inc.
  *	Santosh Shilimkar <santosh.shilimkar@ti.com>
  * Copyright (C) 2012 Ivaylo Dimitrov <freemangordon@abv.bg>
- * Copyright (C) 2013 Pali Roh=C3=A1r <pali.rohar@gmail.com>
+ * Copyright (C) 2013 Pali Roh=C3=A1r <pali@kernel.org>
  */
=20
 #include <linux/arm-smccc.h>
--- a/arch/arm/mach-omap2/omap-secure.h~change-email-address-for-pali-rohar
+++ a/arch/arm/mach-omap2/omap-secure.h
@@ -5,7 +5,7 @@
  * Copyright (C) 2011 Texas Instruments, Inc.
  *	Santosh Shilimkar <santosh.shilimkar@ti.com>
  * Copyright (C) 2012 Ivaylo Dimitrov <freemangordon@abv.bg>
- * Copyright (C) 2013 Pali Roh=C3=A1r <pali.rohar@gmail.com>
+ * Copyright (C) 2013 Pali Roh=C3=A1r <pali@kernel.org>
  */
 #ifndef OMAP_ARCH_OMAP_SECURE_H
 #define OMAP_ARCH_OMAP_SECURE_H
--- a/arch/arm/mach-omap2/omap-smc.S~change-email-address-for-pali-rohar
+++ a/arch/arm/mach-omap2/omap-smc.S
@@ -6,7 +6,7 @@
  * Written by Santosh Shilimkar <santosh.shilimkar@ti.com>
  *
  * Copyright (C) 2012 Ivaylo Dimitrov <freemangordon@abv.bg>
- * Copyright (C) 2013 Pali Roh=C3=A1r <pali.rohar@gmail.com>
+ * Copyright (C) 2013 Pali Roh=C3=A1r <pali@kernel.org>
  */
=20
 #include <linux/linkage.h>
--- a/Documentation/ABI/testing/sysfs-platform-dell-laptop~change-email-add=
ress-for-pali-rohar
+++ a/Documentation/ABI/testing/sysfs-platform-dell-laptop
@@ -2,7 +2,7 @@ What:		/sys/class/leds/dell::kbd_backlig
 Date:		December 2014
 KernelVersion:	3.19
 Contact:	Gabriele Mazzotta <gabriele.mzt@gmail.com>,
-		Pali Roh=C3=A1r <pali.rohar@gmail.com>
+		Pali Roh=C3=A1r <pali@kernel.org>
 Description:
 		This file allows to control the automatic keyboard
 		illumination mode on some systems that have an ambient
@@ -13,7 +13,7 @@ What:		/sys/class/leds/dell::kbd_backlig
 Date:		December 2014
 KernelVersion:	3.19
 Contact:	Gabriele Mazzotta <gabriele.mzt@gmail.com>,
-		Pali Roh=C3=A1r <pali.rohar@gmail.com>
+		Pali Roh=C3=A1r <pali@kernel.org>
 Description:
 		This file allows to specifiy the on/off threshold value,
 		as reported by the ambient light sensor.
@@ -22,7 +22,7 @@ What:		/sys/class/leds/dell::kbd_backlig
 Date:		December 2014
 KernelVersion:	3.19
 Contact:	Gabriele Mazzotta <gabriele.mzt@gmail.com>,
-		Pali Roh=C3=A1r <pali.rohar@gmail.com>
+		Pali Roh=C3=A1r <pali@kernel.org>
 Description:
 		This file allows to control the input triggers that
 		turn on the keyboard backlight illumination that is
@@ -45,7 +45,7 @@ What:		/sys/class/leds/dell::kbd_backlig
 Date:		December 2014
 KernelVersion:	3.19
 Contact:	Gabriele Mazzotta <gabriele.mzt@gmail.com>,
-		Pali Roh=C3=A1r <pali.rohar@gmail.com>
+		Pali Roh=C3=A1r <pali@kernel.org>
 Description:
 		This file allows to specify the interval after which the
 		keyboard illumination is disabled because of inactivity.
--- a/drivers/char/hw_random/omap3-rom-rng.c~change-email-address-for-pali-=
rohar
+++ a/drivers/char/hw_random/omap3-rom-rng.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2009 Nokia Corporation
  * Author: Juha Yrjola <juha.yrjola@solidboot.com>
  *
- * Copyright (C) 2013 Pali Roh=C3=A1r <pali.rohar@gmail.com>
+ * Copyright (C) 2013 Pali Roh=C3=A1r <pali@kernel.org>
  *
  * This file is licensed under  the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
@@ -178,5 +178,5 @@ module_platform_driver(omap3_rom_rng_dri
=20
 MODULE_ALIAS("platform:omap3-rom-rng");
 MODULE_AUTHOR("Juha Yrjola");
-MODULE_AUTHOR("Pali Roh=C3=A1r <pali.rohar@gmail.com>");
+MODULE_AUTHOR("Pali Roh=C3=A1r <pali@kernel.org>");
 MODULE_LICENSE("GPL");
--- a/drivers/hwmon/dell-smm-hwmon.c~change-email-address-for-pali-rohar
+++ a/drivers/hwmon/dell-smm-hwmon.c
@@ -7,7 +7,7 @@
  * Hwmon integration:
  * Copyright (C) 2011  Jean Delvare <jdelvare@suse.de>
  * Copyright (C) 2013, 2014  Guenter Roeck <linux@roeck-us.net>
- * Copyright (C) 2014, 2015  Pali Roh=C3=A1r <pali.rohar@gmail.com>
+ * Copyright (C) 2014, 2015  Pali Roh=C3=A1r <pali@kernel.org>
  */
=20
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -86,7 +86,7 @@ static unsigned int auto_fan;
 #define I8K_HWMON_HAVE_FAN3	(1 << 12)
=20
 MODULE_AUTHOR("Massimo Dal Zotto (dz@debian.org)");
-MODULE_AUTHOR("Pali Roh=C3=A1r <pali.rohar@gmail.com>");
+MODULE_AUTHOR("Pali Roh=C3=A1r <pali@kernel.org>");
 MODULE_DESCRIPTION("Dell laptop SMM BIOS hwmon driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("i8k");
--- a/drivers/platform/x86/dell-laptop.c~change-email-address-for-pali-rohar
+++ a/drivers/platform/x86/dell-laptop.c
@@ -4,7 +4,7 @@
  *
  *  Copyright (c) Red Hat <mjg@redhat.com>
  *  Copyright (c) 2014 Gabriele Mazzotta <gabriele.mzt@gmail.com>
- *  Copyright (c) 2014 Pali Roh=C3=A1r <pali.rohar@gmail.com>
+ *  Copyright (c) 2014 Pali Roh=C3=A1r <pali@kernel.org>
  *
  *  Based on documentation in the libsmbios package:
  *  Copyright (C) 2005-2014 Dell Inc.
@@ -2295,6 +2295,6 @@ module_exit(dell_exit);
=20
 MODULE_AUTHOR("Matthew Garrett <mjg@redhat.com>");
 MODULE_AUTHOR("Gabriele Mazzotta <gabriele.mzt@gmail.com>");
-MODULE_AUTHOR("Pali Roh=C3=A1r <pali.rohar@gmail.com>");
+MODULE_AUTHOR("Pali Roh=C3=A1r <pali@kernel.org>");
 MODULE_DESCRIPTION("Dell laptop driver");
 MODULE_LICENSE("GPL");
--- a/drivers/platform/x86/dell-rbtn.c~change-email-address-for-pali-rohar
+++ a/drivers/platform/x86/dell-rbtn.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
     Dell Airplane Mode Switch driver
-    Copyright (C) 2014-2015  Pali Roh=C3=A1r <pali.rohar@gmail.com>
+    Copyright (C) 2014-2015  Pali Roh=C3=A1r <pali@kernel.org>
=20
 */
=20
@@ -495,5 +495,5 @@ MODULE_PARM_DESC(auto_remove_rfkill, "Au
 				     "(default true)");
 MODULE_DEVICE_TABLE(acpi, rbtn_ids);
 MODULE_DESCRIPTION("Dell Airplane Mode Switch driver");
-MODULE_AUTHOR("Pali Roh=C3=A1r <pali.rohar@gmail.com>");
+MODULE_AUTHOR("Pali Roh=C3=A1r <pali@kernel.org>");
 MODULE_LICENSE("GPL");
--- a/drivers/platform/x86/dell-rbtn.h~change-email-address-for-pali-rohar
+++ a/drivers/platform/x86/dell-rbtn.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
     Dell Airplane Mode Switch driver
-    Copyright (C) 2014-2015  Pali Roh=C3=A1r <pali.rohar@gmail.com>
+    Copyright (C) 2014-2015  Pali Roh=C3=A1r <pali@kernel.org>
=20
 */
=20
--- a/drivers/platform/x86/dell-smbios-base.c~change-email-address-for-pali=
-rohar
+++ a/drivers/platform/x86/dell-smbios-base.c
@@ -4,7 +4,7 @@
  *
  *  Copyright (c) Red Hat <mjg@redhat.com>
  *  Copyright (c) 2014 Gabriele Mazzotta <gabriele.mzt@gmail.com>
- *  Copyright (c) 2014 Pali Roh=C3=A1r <pali.rohar@gmail.com>
+ *  Copyright (c) 2014 Pali Roh=C3=A1r <pali@kernel.org>
  *
  *  Based on documentation in the libsmbios package:
  *  Copyright (C) 2005-2014 Dell Inc.
@@ -645,7 +645,7 @@ module_exit(dell_smbios_exit);
=20
 MODULE_AUTHOR("Matthew Garrett <mjg@redhat.com>");
 MODULE_AUTHOR("Gabriele Mazzotta <gabriele.mzt@gmail.com>");
-MODULE_AUTHOR("Pali Roh=C3=A1r <pali.rohar@gmail.com>");
+MODULE_AUTHOR("Pali Roh=C3=A1r <pali@kernel.org>");
 MODULE_AUTHOR("Mario Limonciello <mario.limonciello@dell.com>");
 MODULE_DESCRIPTION("Common functions for kernel modules using Dell SMBIOS"=
);
 MODULE_LICENSE("GPL");
--- a/drivers/platform/x86/dell-smbios.h~change-email-address-for-pali-rohar
+++ a/drivers/platform/x86/dell-smbios.h
@@ -4,7 +4,7 @@
  *
  *  Copyright (c) Red Hat <mjg@redhat.com>
  *  Copyright (c) 2014 Gabriele Mazzotta <gabriele.mzt@gmail.com>
- *  Copyright (c) 2014 Pali Roh=C3=A1r <pali.rohar@gmail.com>
+ *  Copyright (c) 2014 Pali Roh=C3=A1r <pali@kernel.org>
  *
  *  Based on documentation in the libsmbios package:
  *  Copyright (C) 2005-2014 Dell Inc.
--- a/drivers/platform/x86/dell-smbios-smm.c~change-email-address-for-pali-=
rohar
+++ a/drivers/platform/x86/dell-smbios-smm.c
@@ -4,7 +4,7 @@
  *
  *  Copyright (c) Red Hat <mjg@redhat.com>
  *  Copyright (c) 2014 Gabriele Mazzotta <gabriele.mzt@gmail.com>
- *  Copyright (c) 2014 Pali Roh=C3=A1r <pali.rohar@gmail.com>
+ *  Copyright (c) 2014 Pali Roh=C3=A1r <pali@kernel.org>
  *  Copyright (c) 2017 Dell Inc.
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
--- a/drivers/platform/x86/dell-smo8800.c~change-email-address-for-pali-roh=
ar
+++ a/drivers/platform/x86/dell-smo8800.c
@@ -3,7 +3,7 @@
  *  dell-smo8800.c - Dell Latitude ACPI SMO88XX freefall sensor driver
  *
  *  Copyright (C) 2012 Sonal Santan <sonal.santan@gmail.com>
- *  Copyright (C) 2014 Pali Roh=C3=A1r <pali.rohar@gmail.com>
+ *  Copyright (C) 2014 Pali Roh=C3=A1r <pali@kernel.org>
  *
  *  This is loosely based on lis3lv02d driver.
  */
--- a/drivers/platform/x86/dell-wmi.c~change-email-address-for-pali-rohar
+++ a/drivers/platform/x86/dell-wmi.c
@@ -3,7 +3,7 @@
  * Dell WMI hotkeys
  *
  * Copyright (C) 2008 Red Hat <mjg@redhat.com>
- * Copyright (C) 2014-2015 Pali Roh=C3=A1r <pali.rohar@gmail.com>
+ * Copyright (C) 2014-2015 Pali Roh=C3=A1r <pali@kernel.org>
  *
  * Portions based on wistron_btns.c:
  * Copyright (C) 2005 Miloslav Trmac <mitr@volny.cz>
@@ -29,7 +29,7 @@
 #include "dell-wmi-descriptor.h"
=20
 MODULE_AUTHOR("Matthew Garrett <mjg@redhat.com>");
-MODULE_AUTHOR("Pali Roh=C3=A1r <pali.rohar@gmail.com>");
+MODULE_AUTHOR("Pali Roh=C3=A1r <pali@kernel.org>");
 MODULE_DESCRIPTION("Dell laptop WMI hotkeys driver");
 MODULE_LICENSE("GPL");
=20
--- a/drivers/power/supply/bq2415x_charger.c~change-email-address-for-pali-=
rohar
+++ a/drivers/power/supply/bq2415x_charger.c
@@ -2,7 +2,7 @@
 /*
  * bq2415x charger driver
  *
- * Copyright (C) 2011-2013  Pali Roh=C3=A1r <pali.rohar@gmail.com>
+ * Copyright (C) 2011-2013  Pali Roh=C3=A1r <pali@kernel.org>
  *
  * Datasheets:
  * http://www.ti.com/product/bq24150
@@ -1788,6 +1788,6 @@ static struct i2c_driver bq2415x_driver
 };
 module_i2c_driver(bq2415x_driver);
=20
-MODULE_AUTHOR("Pali Roh=C3=A1r <pali.rohar@gmail.com>");
+MODULE_AUTHOR("Pali Roh=C3=A1r <pali@kernel.org>");
 MODULE_DESCRIPTION("bq2415x charger driver");
 MODULE_LICENSE("GPL");
--- a/drivers/power/supply/bq27xxx_battery.c~change-email-address-for-pali-=
rohar
+++ a/drivers/power/supply/bq27xxx_battery.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2008 Rodolfo Giometti <giometti@linux.it>
  * Copyright (C) 2008 Eurotech S.p.A. <info@eurotech.it>
  * Copyright (C) 2010-2011 Lars-Peter Clausen <lars@metafoo.de>
- * Copyright (C) 2011 Pali Roh=C3=A1r <pali.rohar@gmail.com>
+ * Copyright (C) 2011 Pali Roh=C3=A1r <pali@kernel.org>
  * Copyright (C) 2017 Liam Breck <kernel@networkimprov.net>
  *
  * Based on a previous work by Copyright (C) 2008 Texas Instruments, Inc.
--- a/drivers/power/supply/isp1704_charger.c~change-email-address-for-pali-=
rohar
+++ a/drivers/power/supply/isp1704_charger.c
@@ -3,7 +3,7 @@
  * ISP1704 USB Charger Detection driver
  *
  * Copyright (C) 2010 Nokia Corporation
- * Copyright (C) 2012 - 2013 Pali Roh=C3=A1r <pali.rohar@gmail.com>
+ * Copyright (C) 2012 - 2013 Pali Roh=C3=A1r <pali@kernel.org>
  */
=20
 #include <linux/kernel.h>
--- a/drivers/power/supply/rx51_battery.c~change-email-address-for-pali-roh=
ar
+++ a/drivers/power/supply/rx51_battery.c
@@ -2,7 +2,7 @@
 /*
  * Nokia RX-51 battery driver
  *
- * Copyright (C) 2012  Pali Roh=C3=A1r <pali.rohar@gmail.com>
+ * Copyright (C) 2012  Pali Roh=C3=A1r <pali@kernel.org>
  */
=20
 #include <linux/module.h>
@@ -278,6 +278,6 @@ static struct platform_driver rx51_batte
 module_platform_driver(rx51_battery_driver);
=20
 MODULE_ALIAS("platform:rx51-battery");
-MODULE_AUTHOR("Pali Roh=C3=A1r <pali.rohar@gmail.com>");
+MODULE_AUTHOR("Pali Roh=C3=A1r <pali@kernel.org>");
 MODULE_DESCRIPTION("Nokia RX-51 battery driver");
 MODULE_LICENSE("GPL");
--- a/fs/udf/ecma_167.h~change-email-address-for-pali-rohar
+++ a/fs/udf/ecma_167.h
@@ -5,7 +5,7 @@
  * http://www.ecma.ch
  *
  * Copyright (c) 2001-2002  Ben Fennema
- * Copyright (c) 2017-2019  Pali Roh=C3=A1r <pali.rohar@gmail.com>
+ * Copyright (c) 2017-2019  Pali Roh=C3=A1r <pali@kernel.org>
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
--- a/fs/udf/osta_udf.h~change-email-address-for-pali-rohar
+++ a/fs/udf/osta_udf.h
@@ -5,7 +5,7 @@
  * http://www.osta.org
  *
  * Copyright (c) 2001-2004  Ben Fennema
- * Copyright (c) 2017-2019  Pali Roh=C3=A1r <pali.rohar@gmail.com>
+ * Copyright (c) 2017-2019  Pali Roh=C3=A1r <pali@kernel.org>
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
--- a/include/linux/power/bq2415x_charger.h~change-email-address-for-pali-r=
ohar
+++ a/include/linux/power/bq2415x_charger.h
@@ -2,7 +2,7 @@
 /*
  * bq2415x charger driver
  *
- * Copyright (C) 2011-2013  Pali Roh=C3=A1r <pali.rohar@gmail.com>
+ * Copyright (C) 2011-2013  Pali Roh=C3=A1r <pali@kernel.org>
  */
=20
 #ifndef BQ2415X_CHARGER_H
--- a/MAINTAINERS~change-email-address-for-pali-rohar
+++ a/MAINTAINERS
@@ -727,7 +727,7 @@ L:	linux-alpha@vger.kernel.org
 F:	arch/alpha/
=20
 ALPS PS/2 TOUCHPAD DRIVER
-R:	Pali Roh=C3=A1r <pali.rohar@gmail.com>
+R:	Pali Roh=C3=A1r <pali@kernel.org>
 F:	drivers/input/mouse/alps.*
=20
 ALTERA I2C CONTROLLER DRIVER
@@ -4774,23 +4774,23 @@ F:	drivers/net/fddi/defza.*
=20
 DELL LAPTOP DRIVER
 M:	Matthew Garrett <mjg59@srcf.ucam.org>
-M:	Pali Roh=C3=A1r <pali.rohar@gmail.com>
+M:	Pali Roh=C3=A1r <pali@kernel.org>
 L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
 F:	drivers/platform/x86/dell-laptop.c
=20
 DELL LAPTOP FREEFALL DRIVER
-M:	Pali Roh=C3=A1r <pali.rohar@gmail.com>
+M:	Pali Roh=C3=A1r <pali@kernel.org>
 S:	Maintained
 F:	drivers/platform/x86/dell-smo8800.c
=20
 DELL LAPTOP RBTN DRIVER
-M:	Pali Roh=C3=A1r <pali.rohar@gmail.com>
+M:	Pali Roh=C3=A1r <pali@kernel.org>
 S:	Maintained
 F:	drivers/platform/x86/dell-rbtn.*
=20
 DELL LAPTOP SMM DRIVER
-M:	Pali Roh=C3=A1r <pali.rohar@gmail.com>
+M:	Pali Roh=C3=A1r <pali@kernel.org>
 S:	Maintained
 F:	drivers/hwmon/dell-smm-hwmon.c
 F:	include/uapi/linux/i8k.h
@@ -4802,7 +4802,7 @@ S:	Maintained
 F:	drivers/platform/x86/dell_rbu.c
=20
 DELL SMBIOS DRIVER
-M:	Pali Roh=C3=A1r <pali.rohar@gmail.com>
+M:	Pali Roh=C3=A1r <pali@kernel.org>
 M:	Mario Limonciello <mario.limonciello@dell.com>
 L:	platform-driver-x86@vger.kernel.org
 S:	Maintained
@@ -4835,7 +4835,7 @@ F:	drivers/platform/x86/dell-wmi-descrip
=20
 DELL WMI NOTIFICATIONS DRIVER
 M:	Matthew Garrett <mjg59@srcf.ucam.org>
-M:	Pali Roh=C3=A1r <pali.rohar@gmail.com>
+M:	Pali Roh=C3=A1r <pali@kernel.org>
 S:	Maintained
 F:	drivers/platform/x86/dell-wmi.c
=20
@@ -11950,7 +11950,7 @@ F:	drivers/media/i2c/et8ek8
 F:	drivers/media/i2c/ad5820.c
=20
 NOKIA N900 POWER SUPPLY DRIVERS
-R:	Pali Roh=C3=A1r <pali.rohar@gmail.com>
+R:	Pali Roh=C3=A1r <pali@kernel.org>
 F:	include/linux/power/bq2415x_charger.h
 F:	include/linux/power/bq27xxx_battery.h
 F:	drivers/power/supply/bq2415x_charger.c
--- a/tools/laptop/freefall/freefall.c~change-email-address-for-pali-rohar
+++ a/tools/laptop/freefall/freefall.c
@@ -4,7 +4,7 @@
  * Copyright 2008 Eric Piel
  * Copyright 2009 Pavel Machek <pavel@ucw.cz>
  * Copyright 2012 Sonal Santan
- * Copyright 2014 Pali Roh=C3=A1r <pali.rohar@gmail.com>
+ * Copyright 2014 Pali Roh=C3=A1r <pali@kernel.org>
  */
=20
 #include <stdio.h>
_
