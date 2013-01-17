From: akpm@linux-foundation.org
Subject: + arm-mvebu-update-defconfig-with-marvell-rtc-support.patch added to -mm tree
Date: Wed, 16 Jan 2013 16:03:38 -0800
Message-ID: <20130117000339.4D5E031C174@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:49003 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab3AQADk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Jan 2013 19:03:40 -0500
Received: by mail-qc0-f201.google.com with SMTP id a6so241896qch.4
        for <mm-commits@vger.kernel.org>; Wed, 16 Jan 2013 16:03:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gregory.clement@free-electrons.com, andrew@lunn.ch, linux@arm.linux.org.uk


The patch titled
     Subject: arm: mvebu: update defconfig with Marvell RTC support
has been added to the -mm tree.  Its filename is
     arm-mvebu-update-defconfig-with-marvell-rtc-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -39,6 +39,7 @@ CONFIG_GPIO_SYSFS=y
 # CONFIG_USB_SUPPORT is not set
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_S35390A=y
+CONFIG_RTC_DRV_MV=y
 CONFIG_DMADEVICES=y
 CONFIG_MV_XOR=y
 # CONFIG_IOMMU_SUPPORT is not set
_

Patches currently in -mm which might be from gregory.clement@free-electrons.com are

linux-next.patch
rtc-add-support-of-rtc-mv-for-mvebu-socs.patch
arm-mvebu-add-rtc-support-for-armada-370-and-armada-xp.patch
arm-mvebu-update-defconfig-with-marvell-rtc-support.patch

