From: akpm@linux-foundation.org
Subject: [merged] arm-mvebu-update-defconfig-with-marvell-rtc-support.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:36:55 -0800
Message-ID: <20130222203657.8C5EB31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:50538 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab3BVUhB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:37:01 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so119023qaj.5
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:37:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gregory.clement@free-electrons.com, andrew@lunn.ch, linux@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: arm: mvebu: update defconfig with Marvell RTC support
has been removed from the -mm tree.  Its filename was
     arm-mvebu-update-defconfig-with-marvell-rtc-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: arm: mvebu: update defconfig with Marvell RTC support

The RTC class driver is already part of the mvebu_defconfig but the
Marvell internal RTC not yet.  Now that its support is added for mvebu
let's update the config file.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/configs/mvebu_defconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/arm/configs/mvebu_defconfig~arm-mvebu-update-defconfig-with-marvell-rtc-support arch/arm/configs/mvebu_defconfig
--- a/arch/arm/configs/mvebu_defconfig~arm-mvebu-update-defconfig-with-marvell-rtc-support
+++ a/arch/arm/configs/mvebu_defconfig
@@ -41,6 +41,7 @@ CONFIG_GPIO_SYSFS=y
 # CONFIG_USB_SUPPORT is not set
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_S35390A=y
+CONFIG_RTC_DRV_MV=y
 CONFIG_DMADEVICES=y
 CONFIG_MV_XOR=y
 # CONFIG_IOMMU_SUPPORT is not set
_

Patches currently in -mm which might be from gregory.clement@free-electrons.com are

origin.patch
linux-next.patch

