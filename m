Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44AD0C433C1
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:32:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EACF6193F
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbhC1Wbw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 18:31:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231565AbhC1Wbn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 18:31:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A307B6192F;
        Sun, 28 Mar 2021 22:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616970702;
        bh=Ocbf27+fMA4eaTfZsBHh5KTNRTuZA7fBC572EWp6RRw=;
        h=Date:From:To:Subject:From;
        b=y+SoYt2PYpKmmPa7jgRtm8j/+ryEJCDndp137VQa+SnBi1D+y0dGC2pwF4Sf7Nerj
         WouiRW4PH6UyCCXTJkf71+MHXh+Q3PqBQUg6HMKUbDcDIT790tJvoO8Cow5CWaSGLF
         sCgm+gLu8wJs8XbaE4g3iUDw3FIrqo4YdbwEejOQ=
Date:   Sun, 28 Mar 2021 15:31:42 -0700
From:   akpm@linux-foundation.org
To:     bgolaszewski@baylibre.com, gregkh@linuxfoundation.org,
        jassisinghbrar@gmail.com, kabel@kernel.org,
        linus.walleij@linaro.org, mm-commits@vger.kernel.org, pavel@ucw.cz
Subject:  + treewide-change-my-e-mail-address-fix-my-name.patch
 added to -mm tree
Message-ID: <20210328223142.DGgQnxPSZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: treewide: change my e-mail address, fix my name
has been added to the -mm tree.  Its filename is
     treewide-change-my-e-mail-address-fix-my-name.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/treewide-change-my-e-mail-add=
ress-fix-my-name.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/treewide-change-my-e-mail-add=
ress-fix-my-name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Marek Beh=C3=BAn <kabel@kernel.org>
Subject: treewide: change my e-mail address, fix my name

Change my e-mail address to kabel@kernel.org, and fix my name in
non-code parts (add diacritical mark).

Link: https://lkml.kernel.org/r/20210325171123.28093-2-kabel@kernel.org
Signed-off-by: Marek Beh=C3=BAn <kabel@kernel.org>
Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/debugfs-moxtet                            |    4=
 ++--
 Documentation/ABI/testing/debugfs-turris-mox-rwtm                   |    2=
 +-
 Documentation/ABI/testing/sysfs-bus-moxtet-devices                  |    6=
 +++---
 Documentation/ABI/testing/sysfs-class-led-driver-turris-omnia       |    2=
 +-
 Documentation/ABI/testing/sysfs-firmware-turris-mox-rwtm            |   10=
 +++++-----
 Documentation/devicetree/bindings/leds/cznic,turris-omnia-leds.yaml |    2=
 +-
 MAINTAINERS                                                         |    2=
 +-
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts              |    2=
 +-
 drivers/bus/moxtet.c                                                |    4=
 ++--
 drivers/firmware/turris-mox-rwtm.c                                  |    4=
 ++--
 drivers/gpio/gpio-moxtet.c                                          |    4=
 ++--
 drivers/leds/leds-turris-omnia.c                                    |    4=
 ++--
 drivers/mailbox/armada-37xx-rwtm-mailbox.c                          |    4=
 ++--
 drivers/watchdog/armada_37xx_wdt.c                                  |    4=
 ++--
 include/dt-bindings/bus/moxtet.h                                    |    2=
 +-
 include/linux/armada-37xx-rwtm-mailbox.h                            |    2=
 +-
 include/linux/moxtet.h                                              |    2=
 +-
 17 files changed, 30 insertions(+), 30 deletions(-)

--- a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts~treewide-chang=
e-my-e-mail-address-fix-my-name
+++ a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: (GPL-2.0+ OR MIT)
 /*
  * Device Tree file for CZ.NIC Turris Mox Board
- * 2019 by Marek Behun <marek.behun@nic.cz>
+ * 2019 by Marek Beh=C3=BAn <kabel@kernel.org>
  */
=20
 /dts-v1/;
--- a/Documentation/ABI/testing/debugfs-moxtet~treewide-change-my-e-mail-ad=
dress-fix-my-name
+++ a/Documentation/ABI/testing/debugfs-moxtet
@@ -1,7 +1,7 @@
 What:		/sys/kernel/debug/moxtet/input
 Date:		March 2019
 KernelVersion:	5.3
-Contact:	Marek Beh=C3=BAn <marek.behun@nic.cz>
+Contact:	Marek Beh=C3=BAn <kabel@kernel.org>
 Description:	(Read) Read input from the shift registers, in hexadecimal.
 		Returns N+1 bytes, where N is the number of Moxtet connected
 		modules. The first byte is from the CPU board itself.
@@ -19,7 +19,7 @@ Description:	(Read) Read input from the
 What:		/sys/kernel/debug/moxtet/output
 Date:		March 2019
 KernelVersion:	5.3
-Contact:	Marek Beh=C3=BAn <marek.behun@nic.cz>
+Contact:	Marek Beh=C3=BAn <kabel@kernel.org>
 Description:	(RW) Read last written value to the shift registers, in
 		hexadecimal, or write values to the shift registers, also
 		in hexadecimal.
--- a/Documentation/ABI/testing/debugfs-turris-mox-rwtm~treewide-change-my-=
e-mail-address-fix-my-name
+++ a/Documentation/ABI/testing/debugfs-turris-mox-rwtm
@@ -1,7 +1,7 @@
 What:		/sys/kernel/debug/turris-mox-rwtm/do_sign
 Date:		Jun 2020
 KernelVersion:	5.8
-Contact:	Marek Beh=C3=BAn <marek.behun@nic.cz>
+Contact:	Marek Beh=C3=BAn <kabel@kernel.org>
 Description:
=20
 		=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/Documentation/ABI/testing/sysfs-bus-moxtet-devices~treewide-change-my=
-e-mail-address-fix-my-name
+++ a/Documentation/ABI/testing/sysfs-bus-moxtet-devices
@@ -1,17 +1,17 @@
 What:		/sys/bus/moxtet/devices/moxtet-<name>.<addr>/module_description
 Date:		March 2019
 KernelVersion:	5.3
-Contact:	Marek Beh=C3=BAn <marek.behun@nic.cz>
+Contact:	Marek Beh=C3=BAn <kabel@kernel.org>
 Description:	(Read) Moxtet module description. Format: string
=20
 What:		/sys/bus/moxtet/devices/moxtet-<name>.<addr>/module_id
 Date:		March 2019
 KernelVersion:	5.3
-Contact:	Marek Beh=C3=BAn <marek.behun@nic.cz>
+Contact:	Marek Beh=C3=BAn <kabel@kernel.org>
 Description:	(Read) Moxtet module ID. Format: %x
=20
 What:		/sys/bus/moxtet/devices/moxtet-<name>.<addr>/module_name
 Date:		March 2019
 KernelVersion:	5.3
-Contact:	Marek Beh=C3=BAn <marek.behun@nic.cz>
+Contact:	Marek Beh=C3=BAn <kabel@kernel.org>
 Description:	(Read) Moxtet module name. Format: string
--- a/Documentation/ABI/testing/sysfs-class-led-driver-turris-omnia~treewid=
e-change-my-e-mail-address-fix-my-name
+++ a/Documentation/ABI/testing/sysfs-class-led-driver-turris-omnia
@@ -1,7 +1,7 @@
 What:		/sys/class/leds/<led>/device/brightness
 Date:		July 2020
 KernelVersion:	5.9
-Contact:	Marek Beh=C3=BAn <marek.behun@nic.cz>
+Contact:	Marek Beh=C3=BAn <kabel@kernel.org>
 Description:	(RW) On the front panel of the Turris Omnia router there is a=
lso
 		a button which can be used to control the intensity of all the
 		LEDs at once, so that if they are too bright, user can dim them.
--- a/Documentation/ABI/testing/sysfs-firmware-turris-mox-rwtm~treewide-cha=
nge-my-e-mail-address-fix-my-name
+++ a/Documentation/ABI/testing/sysfs-firmware-turris-mox-rwtm
@@ -1,21 +1,21 @@
 What:		/sys/firmware/turris-mox-rwtm/board_version
 Date:		August 2019
 KernelVersion:	5.4
-Contact:	Marek Beh=C3=BAn <marek.behun@nic.cz>
+Contact:	Marek Beh=C3=BAn <kabel@kernel.org>
 Description:	(Read) Board version burned into eFuses of this Turris Mox bo=
ard.
 		Format: %i
=20
 What:		/sys/firmware/turris-mox-rwtm/mac_address*
 Date:		August 2019
 KernelVersion:	5.4
-Contact:	Marek Beh=C3=BAn <marek.behun@nic.cz>
+Contact:	Marek Beh=C3=BAn <kabel@kernel.org>
 Description:	(Read) MAC addresses burned into eFuses of this Turris Mox bo=
ard.
 		Format: %pM
=20
 What:		/sys/firmware/turris-mox-rwtm/pubkey
 Date:		August 2019
 KernelVersion:	5.4
-Contact:	Marek Beh=C3=BAn <marek.behun@nic.cz>
+Contact:	Marek Beh=C3=BAn <kabel@kernel.org>
 Description:	(Read) ECDSA public key (in pubkey hex compressed form) compu=
ted
 		as pair to the ECDSA private key burned into eFuses of this
 		Turris Mox Board.
@@ -24,7 +24,7 @@ Description:	(Read) ECDSA public key (in
 What:		/sys/firmware/turris-mox-rwtm/ram_size
 Date:		August 2019
 KernelVersion:	5.4
-Contact:	Marek Beh=C3=BAn <marek.behun@nic.cz>
+Contact:	Marek Beh=C3=BAn <kabel@kernel.org>
 Description:	(Read) RAM size in MiB of this Turris Mox board as was detect=
ed
 		during manufacturing and burned into eFuses. Can be 512 or 1024.
 		Format: %i
@@ -32,6 +32,6 @@ Description:	(Read) RAM size in MiB of t
 What:		/sys/firmware/turris-mox-rwtm/serial_number
 Date:		August 2019
 KernelVersion:	5.4
-Contact:	Marek Beh=C3=BAn <marek.behun@nic.cz>
+Contact:	Marek Beh=C3=BAn <kabel@kernel.org>
 Description:	(Read) Serial number burned into eFuses of this Turris Mox de=
vice.
 		Format: %016X
--- a/Documentation/devicetree/bindings/leds/cznic,turris-omnia-leds.yaml~t=
reewide-change-my-e-mail-address-fix-my-name
+++ a/Documentation/devicetree/bindings/leds/cznic,turris-omnia-leds.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-sche
 title: CZ.NIC's Turris Omnia LEDs driver
=20
 maintainers:
-  - Marek Beh=C3=BAn <marek.behun@nic.cz>
+  - Marek Beh=C3=BAn <kabel@kernel.org>
=20
 description:
   This module adds support for the RGB LEDs found on the front panel of the
--- a/drivers/bus/moxtet.c~treewide-change-my-e-mail-address-fix-my-name
+++ a/drivers/bus/moxtet.c
@@ -2,7 +2,7 @@
 /*
  * Turris Mox module configuration bus driver
  *
- * Copyright (C) 2019 Marek Behun <marek.behun@nic.cz>
+ * Copyright (C) 2019 Marek Beh=C3=BAn <kabel@kernel.org>
  */
=20
 #include <dt-bindings/bus/moxtet.h>
@@ -879,6 +879,6 @@ static void __exit moxtet_exit(void)
 }
 module_exit(moxtet_exit);
=20
-MODULE_AUTHOR("Marek Behun <marek.behun@nic.cz>");
+MODULE_AUTHOR("Marek Behun <kabel@kernel.org>");
 MODULE_DESCRIPTION("CZ.NIC's Turris Mox module configuration bus");
 MODULE_LICENSE("GPL v2");
--- a/drivers/firmware/turris-mox-rwtm.c~treewide-change-my-e-mail-address-=
fix-my-name
+++ a/drivers/firmware/turris-mox-rwtm.c
@@ -2,7 +2,7 @@
 /*
  * Turris Mox rWTM firmware driver
  *
- * Copyright (C) 2019 Marek Behun <marek.behun@nic.cz>
+ * Copyright (C) 2019 Marek Beh=C3=BAn <kabel@kernel.org>
  */
=20
 #include <linux/armada-37xx-rwtm-mailbox.h>
@@ -547,4 +547,4 @@ module_platform_driver(turris_mox_rwtm_d
=20
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Turris Mox rWTM firmware driver");
-MODULE_AUTHOR("Marek Behun <marek.behun@nic.cz>");
+MODULE_AUTHOR("Marek Behun <kabel@kernel.org>");
--- a/drivers/gpio/gpio-moxtet.c~treewide-change-my-e-mail-address-fix-my-n=
ame
+++ a/drivers/gpio/gpio-moxtet.c
@@ -2,7 +2,7 @@
 /*
  *  Turris Mox Moxtet GPIO expander
  *
- *  Copyright (C) 2018 Marek Behun <marek.behun@nic.cz>
+ *  Copyright (C) 2018 Marek Beh=C3=BAn <kabel@kernel.org>
  */
=20
 #include <linux/bitops.h>
@@ -174,6 +174,6 @@ static struct moxtet_driver moxtet_gpio_
 };
 module_moxtet_driver(moxtet_gpio_driver);
=20
-MODULE_AUTHOR("Marek Behun <marek.behun@nic.cz>");
+MODULE_AUTHOR("Marek Behun <kabel@kernel.org>");
 MODULE_DESCRIPTION("Turris Mox Moxtet GPIO expander");
 MODULE_LICENSE("GPL v2");
--- a/drivers/leds/leds-turris-omnia.c~treewide-change-my-e-mail-address-fi=
x-my-name
+++ a/drivers/leds/leds-turris-omnia.c
@@ -2,7 +2,7 @@
 /*
  * CZ.NIC's Turris Omnia LEDs driver
  *
- * 2020 by Marek Behun <marek.behun@nic.cz>
+ * 2020 by Marek Beh=C3=BAn <kabel@kernel.org>
  */
=20
 #include <linux/i2c.h>
@@ -287,6 +287,6 @@ static struct i2c_driver omnia_leds_driv
=20
 module_i2c_driver(omnia_leds_driver);
=20
-MODULE_AUTHOR("Marek Behun <marek.behun@nic.cz>");
+MODULE_AUTHOR("Marek Behun <kabel@kernel.org>");
 MODULE_DESCRIPTION("CZ.NIC's Turris Omnia LEDs");
 MODULE_LICENSE("GPL v2");
--- a/drivers/mailbox/armada-37xx-rwtm-mailbox.c~treewide-change-my-e-mail-=
address-fix-my-name
+++ a/drivers/mailbox/armada-37xx-rwtm-mailbox.c
@@ -2,7 +2,7 @@
 /*
  * rWTM BIU Mailbox driver for Armada 37xx
  *
- * Author: Marek Behun <marek.behun@nic.cz>
+ * Author: Marek Beh=C3=BAn <kabel@kernel.org>
  */
=20
 #include <linux/device.h>
@@ -203,4 +203,4 @@ module_platform_driver(armada_37xx_mbox_
=20
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("rWTM BIU Mailbox driver for Armada 37xx");
-MODULE_AUTHOR("Marek Behun <marek.behun@nic.cz>");
+MODULE_AUTHOR("Marek Behun <kabel@kernel.org>");
--- a/drivers/watchdog/armada_37xx_wdt.c~treewide-change-my-e-mail-address-=
fix-my-name
+++ a/drivers/watchdog/armada_37xx_wdt.c
@@ -2,7 +2,7 @@
 /*
  * Watchdog driver for Marvell Armada 37xx SoCs
  *
- * Author: Marek Behun <marek.behun@nic.cz>
+ * Author: Marek Beh=C3=BAn <kabel@kernel.org>
  */
=20
 #include <linux/clk.h>
@@ -366,7 +366,7 @@ static struct platform_driver armada_37x
=20
 module_platform_driver(armada_37xx_wdt_driver);
=20
-MODULE_AUTHOR("Marek Behun <marek.behun@nic.cz>");
+MODULE_AUTHOR("Marek Behun <kabel@kernel.org>");
 MODULE_DESCRIPTION("Armada 37xx CPU Watchdog");
=20
 MODULE_LICENSE("GPL v2");
--- a/include/dt-bindings/bus/moxtet.h~treewide-change-my-e-mail-address-fi=
x-my-name
+++ a/include/dt-bindings/bus/moxtet.h
@@ -2,7 +2,7 @@
 /*
  * Constant for device tree bindings for Turris Mox module configuration b=
us
  *
- * Copyright (C) 2019 Marek Behun <marek.behun@nic.cz>
+ * Copyright (C) 2019 Marek Beh=C3=BAn <kabel@kernel.org>
  */
=20
 #ifndef _DT_BINDINGS_BUS_MOXTET_H
--- a/include/linux/armada-37xx-rwtm-mailbox.h~treewide-change-my-e-mail-ad=
dress-fix-my-name
+++ a/include/linux/armada-37xx-rwtm-mailbox.h
@@ -2,7 +2,7 @@
 /*
  * rWTM BIU Mailbox driver for Armada 37xx
  *
- * Author: Marek Behun <marek.behun@nic.cz>
+ * Author: Marek Beh=C3=BAn <kabel@kernel.org>
  */
=20
 #ifndef _LINUX_ARMADA_37XX_RWTM_MAILBOX_H_
--- a/include/linux/moxtet.h~treewide-change-my-e-mail-address-fix-my-name
+++ a/include/linux/moxtet.h
@@ -2,7 +2,7 @@
 /*
  * Turris Mox module configuration bus driver
  *
- * Copyright (C) 2019 Marek Behun <marek.behun@nic.cz>
+ * Copyright (C) 2019 Marek Beh=C3=BAn <kabel@kernel.org>
  */
=20
 #ifndef __LINUX_MOXTET_H
--- a/MAINTAINERS~treewide-change-my-e-mail-address-fix-my-name
+++ a/MAINTAINERS
@@ -1791,7 +1791,7 @@ F:	drivers/pinctrl/pinctrl-gemini.c
 F:	drivers/rtc/rtc-ftrtc010.c
=20
 ARM/CZ.NIC TURRIS SUPPORT
-M:	Marek Behun <marek.behun@nic.cz>
+M:	Marek Behun <kabel@kernel.org>
 S:	Maintained
 W:	https://www.turris.cz/
 F:	Documentation/ABI/testing/debugfs-moxtet
_

Patches currently in -mm which might be from kabel@kernel.org are

maintainers-update-cznics-turris-information.patch
treewide-change-my-e-mail-address-fix-my-name.patch

