From: akpm@linux-foundation.org
Subject: + rtc-add-support-of-rtc-mv-for-mvebu-socs.patch added to -mm tree
Date: Thu, 17 Jan 2013 15:43:50 -0800
Message-ID: <20130117234350.A4C3D5A41EB@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f201.google.com ([209.85.210.201]:42069 "EHLO
	mail-ia0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab3AQXnw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jan 2013 18:43:52 -0500
Received: by mail-ia0-f201.google.com with SMTP id t4so230717iag.4
        for <mm-commits@vger.kernel.org>; Thu, 17 Jan 2013 15:43:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gregory.clement@free-electrons.com, andrew@lunn.ch, linux@arm.linux.org.uk


The patch titled
     Subject: rtc: add support of rtc-mv for MVEBU SoCs
has been added to the -mm tree.  Its filename is
     rtc-add-support-of-rtc-mv-for-mvebu-socs.patch

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
@@ -1055,7 +1055,7 @@ config RTC_DRV_TX4939
 
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
rtc-add-support-of-rtc-mv-for-mvebu-socs.patch
arm-mvebu-add-rtc-support-for-armada-370-and-armada-xp.patch
arm-mvebu-update-defconfig-with-marvell-rtc-support.patch

