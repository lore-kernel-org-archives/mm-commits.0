From: akpm@linux-foundation.org
Subject: [merged] rtc-add-support-of-rtc-mv-for-mvebu-socs.patch removed from -mm tree
Date: Wed, 06 Feb 2013 12:22:03 -0800
Message-ID: <20130206202205.4F36D31C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:37799 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756913Ab3BFUWJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 15:22:09 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so193343vcd.3
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 12:22:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gregory.clement@free-electrons.com, andrew@lunn.ch, linux@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: add support of rtc-mv for MVEBU SoCs
has been removed from the -mm tree.  Its filename was
     rtc-add-support-of-rtc-mv-for-mvebu-socs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: rtc: add support of rtc-mv for MVEBU SoCs

The Armada 370 and Armada XP Socs have the same controller that the one
used in the orion platforms.  This patch enables the selection of rtc-mv
with mvebu platforms.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Acked-by: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/Kconfig~rtc-add-support-of-rtc-mv-for-mvebu-socs drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-add-support-of-rtc-mv-for-mvebu-socs
+++ a/drivers/rtc/Kconfig
@@ -1065,7 +1065,7 @@ config RTC_DRV_TX4939
 
 config RTC_DRV_MV
 	tristate "Marvell SoC RTC"
-	depends on ARCH_KIRKWOOD || ARCH_DOVE
+	depends on ARCH_KIRKWOOD || ARCH_DOVE || ARCH_MVEBU
 	help
 	  If you say yes here you will get support for the in-chip RTC
 	  that can be found in some of Marvell's SoC devices, such as
_

Patches currently in -mm which might be from gregory.clement@free-electrons.com are

linux-next.patch
arm-mvebu-add-rtc-support-for-armada-370-and-armada-xp.patch
arm-mvebu-update-defconfig-with-marvell-rtc-support.patch

