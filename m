From: akpm@linux-foundation.org
Subject: + pratyush-anand-has-moved.patch added to -mm tree
Date: Wed, 06 May 2015 15:39:40 -0700
Message-ID: <554a982c.zRYhv8luZVfodioC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55791 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbbEFWjl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 May 2015 18:39:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pratyush.anand@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Pratyush Anand has moved
has been added to the -mm tree.  Its filename is
     pratyush-anand-has-moved.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pratyush-anand-has-moved.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pratyush-anand-has-moved.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pratyush Anand <pratyush.anand@gmail.com>
Subject: Pratyush Anand has moved

pratyush.anand@st.com email-id doesn't exist anymore as I have left the
company.  Replace ST's id with pratyush.anand@gmail.com.

Signed-off-by: Pratyush Anand <pratyush.anand@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap                                             |    1 
 Documentation/ABI/testing/configfs-spear-pcie-gadget |    2 -
 Documentation/ABI/testing/sysfs-bus-usb-lvstest      |   12 +++++-----
 Documentation/misc-devices/spear-pcie-gadget.txt     |    2 -
 drivers/misc/spear13xx_pcie_gadget.c                 |    2 -
 drivers/pci/host/pcie-spear13xx.c                    |    4 +--
 drivers/phy/phy-spear1310-miphy.c                    |    4 +--
 drivers/phy/phy-spear1340-miphy.c                    |    4 +--
 drivers/usb/misc/lvstest.c                           |    2 -
 9 files changed, 17 insertions(+), 16 deletions(-)

diff -puN .mailmap~pratyush-anand-has-moved .mailmap
--- a/.mailmap~pratyush-anand-has-moved
+++ a/.mailmap
@@ -95,6 +95,7 @@ Patrick Mochel <mochel@digitalimplant.or
 Peter A Jonsson <pj@ludd.ltu.se>
 Peter Oruba <peter@oruba.de>
 Peter Oruba <peter.oruba@amd.com>
+Pratyush Anand <pratyush.anand@gmail.com> <pratyush.anand@st.com>
 Praveen BP <praveenbp@ti.com>
 Rajesh Shah <rajesh.shah@intel.com>
 Ralf Baechle <ralf@linux-mips.org>
diff -puN Documentation/ABI/testing/configfs-spear-pcie-gadget~pratyush-anand-has-moved Documentation/ABI/testing/configfs-spear-pcie-gadget
--- a/Documentation/ABI/testing/configfs-spear-pcie-gadget~pratyush-anand-has-moved
+++ a/Documentation/ABI/testing/configfs-spear-pcie-gadget
@@ -1,7 +1,7 @@
 What:		/config/pcie-gadget
 Date:		Feb 2011
 KernelVersion:	2.6.37
-Contact:	Pratyush Anand <pratyush.anand@st.com>
+Contact:	Pratyush Anand <pratyush.anand@gmail.com>
 Description:
 
 	Interface is used to configure selected dual mode PCIe controller
diff -puN Documentation/ABI/testing/sysfs-bus-usb-lvstest~pratyush-anand-has-moved Documentation/ABI/testing/sysfs-bus-usb-lvstest
--- a/Documentation/ABI/testing/sysfs-bus-usb-lvstest~pratyush-anand-has-moved
+++ a/Documentation/ABI/testing/sysfs-bus-usb-lvstest
@@ -4,14 +4,14 @@ driver is bound with root hub device.
 
 What:		/sys/bus/usb/devices/.../get_dev_desc
 Date:		March 2014
-Contact:	Pratyush Anand <pratyush.anand@st.com>
+Contact:	Pratyush Anand <pratyush.anand@gmail.com>
 Description:
 		Write to this node to issue "Get Device Descriptor"
 		for Link Layer Validation device. It is needed for TD.7.06.
 
 What:		/sys/bus/usb/devices/.../u1_timeout
 Date:		March 2014
-Contact:	Pratyush Anand <pratyush.anand@st.com>
+Contact:	Pratyush Anand <pratyush.anand@gmail.com>
 Description:
 		Set "U1 timeout" for the downstream port where Link Layer
 		Validation device is connected. Timeout value must be between 0
@@ -19,7 +19,7 @@ Description:
 
 What:		/sys/bus/usb/devices/.../u2_timeout
 Date:		March 2014
-Contact:	Pratyush Anand <pratyush.anand@st.com>
+Contact:	Pratyush Anand <pratyush.anand@gmail.com>
 Description:
 		Set "U2 timeout" for the downstream port where Link Layer
 		Validation device is connected. Timeout value must be between 0
@@ -27,21 +27,21 @@ Description:
 
 What:		/sys/bus/usb/devices/.../hot_reset
 Date:		March 2014
-Contact:	Pratyush Anand <pratyush.anand@st.com>
+Contact:	Pratyush Anand <pratyush.anand@gmail.com>
 Description:
 		Write to this node to issue "Reset" for Link Layer Validation
 		device. It is needed for TD.7.29, TD.7.31, TD.7.34 and TD.7.35.
 
 What:		/sys/bus/usb/devices/.../u3_entry
 Date:		March 2014
-Contact:	Pratyush Anand <pratyush.anand@st.com>
+Contact:	Pratyush Anand <pratyush.anand@gmail.com>
 Description:
 		Write to this node to issue "U3 entry" for Link Layer
 		Validation device. It is needed for TD.7.35 and TD.7.36.
 
 What:		/sys/bus/usb/devices/.../u3_exit
 Date:		March 2014
-Contact:	Pratyush Anand <pratyush.anand@st.com>
+Contact:	Pratyush Anand <pratyush.anand@gmail.com>
 Description:
 		Write to this node to issue "U3 exit" for Link Layer
 		Validation device. It is needed for TD.7.36.
diff -puN Documentation/misc-devices/spear-pcie-gadget.txt~pratyush-anand-has-moved Documentation/misc-devices/spear-pcie-gadget.txt
--- a/Documentation/misc-devices/spear-pcie-gadget.txt~pratyush-anand-has-moved
+++ a/Documentation/misc-devices/spear-pcie-gadget.txt
@@ -2,7 +2,7 @@ Spear PCIe Gadget Driver:
 
 Author
 =============
-Pratyush Anand (pratyush.anand@st.com)
+Pratyush Anand (pratyush.anand@gmail.com)
 
 Location
 ============
diff -puN drivers/misc/spear13xx_pcie_gadget.c~pratyush-anand-has-moved drivers/misc/spear13xx_pcie_gadget.c
--- a/drivers/misc/spear13xx_pcie_gadget.c~pratyush-anand-has-moved
+++ a/drivers/misc/spear13xx_pcie_gadget.c
@@ -2,7 +2,7 @@
  * drivers/misc/spear13xx_pcie_gadget.c
  *
  * Copyright (C) 2010 ST Microelectronics
- * Pratyush Anand<pratyush.anand@st.com>
+ * Pratyush Anand<pratyush.anand@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff -puN drivers/pci/host/pcie-spear13xx.c~pratyush-anand-has-moved drivers/pci/host/pcie-spear13xx.c
--- a/drivers/pci/host/pcie-spear13xx.c~pratyush-anand-has-moved
+++ a/drivers/pci/host/pcie-spear13xx.c
@@ -4,7 +4,7 @@
  * SPEAr13xx PCIe Glue Layer Source Code
  *
  * Copyright (C) 2010-2014 ST Microelectronics
- * Pratyush Anand <pratyush.anand@st.com>
+ * Pratyush Anand <pratyush.anand@gmail.com>
  * Mohit Kumar <mohit.kumar@st.com>
  *
  * This file is licensed under the terms of the GNU General Public
@@ -387,5 +387,5 @@ static int __init spear13xx_pcie_init(vo
 module_init(spear13xx_pcie_init);
 
 MODULE_DESCRIPTION("ST Microelectronics SPEAr13xx PCIe host controller driver");
-MODULE_AUTHOR("Pratyush Anand <pratyush.anand@st.com>");
+MODULE_AUTHOR("Pratyush Anand <pratyush.anand@gmail.com>");
 MODULE_LICENSE("GPL v2");
diff -puN drivers/phy/phy-spear1310-miphy.c~pratyush-anand-has-moved drivers/phy/phy-spear1310-miphy.c
--- a/drivers/phy/phy-spear1310-miphy.c~pratyush-anand-has-moved
+++ a/drivers/phy/phy-spear1310-miphy.c
@@ -2,7 +2,7 @@
  * ST SPEAr1310-miphy driver
  *
  * Copyright (C) 2014 ST Microelectronics
- * Pratyush Anand <pratyush.anand@st.com>
+ * Pratyush Anand <pratyush.anand@gmail.com>
  * Mohit Kumar <mohit.kumar@st.com>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -257,5 +257,5 @@ static struct platform_driver spear1310_
 module_platform_driver(spear1310_miphy_driver);
 
 MODULE_DESCRIPTION("ST SPEAR1310-MIPHY driver");
-MODULE_AUTHOR("Pratyush Anand <pratyush.anand@st.com>");
+MODULE_AUTHOR("Pratyush Anand <pratyush.anand@gmail.com>");
 MODULE_LICENSE("GPL v2");
diff -puN drivers/phy/phy-spear1340-miphy.c~pratyush-anand-has-moved drivers/phy/phy-spear1340-miphy.c
--- a/drivers/phy/phy-spear1340-miphy.c~pratyush-anand-has-moved
+++ a/drivers/phy/phy-spear1340-miphy.c
@@ -2,7 +2,7 @@
  * ST spear1340-miphy driver
  *
  * Copyright (C) 2014 ST Microelectronics
- * Pratyush Anand <pratyush.anand@st.com>
+ * Pratyush Anand <pratyush.anand@gmail.com>
  * Mohit Kumar <mohit.kumar@st.com>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -290,5 +290,5 @@ static struct platform_driver spear1340_
 module_platform_driver(spear1340_miphy_driver);
 
 MODULE_DESCRIPTION("ST SPEAR1340-MIPHY driver");
-MODULE_AUTHOR("Pratyush Anand <pratyush.anand@st.com>");
+MODULE_AUTHOR("Pratyush Anand <pratyush.anand@gmail.com>");
 MODULE_LICENSE("GPL v2");
diff -puN drivers/usb/misc/lvstest.c~pratyush-anand-has-moved drivers/usb/misc/lvstest.c
--- a/drivers/usb/misc/lvstest.c~pratyush-anand-has-moved
+++ a/drivers/usb/misc/lvstest.c
@@ -4,7 +4,7 @@
  * Test pattern generation for Link Layer Validation System Tests
  *
  * Copyright (C) 2014 ST Microelectronics
- * Pratyush Anand <pratyush.anand@st.com>
+ * Pratyush Anand <pratyush.anand@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
_

Patches currently in -mm which might be from pratyush.anand@gmail.com are

pratyush-anand-has-moved.patch
mohit-kumar-has-moved.patch

