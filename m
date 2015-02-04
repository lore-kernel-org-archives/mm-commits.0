From: akpm@linux-foundation.org
Subject: +
 arm-mvebu-enable-armada-38x-rtc-driver-in-mvebu_v7_defconfig.patch added to -mm tree
Date: Wed, 04 Feb 2015 14:49:27 -0800
Message-ID: <54d2a1f7.v4cQyataOlfGWukv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933704AbbBDWt3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Feb 2015 17:49:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gregory.clement@free-electrons.com, a.zummo@towertech.it, alior@marvell.com, andrew@lunn.ch, arno@natisbad.org, boris.brezillon@free-electrons.com, ezequiel.garcia@free-electrons.com, jason@lakedaemon.net, mark.rutland@arm.com, maxime.ripard@free-electrons.com, nadavh@marvell.com, sebastian.hesselbarth@gmail.com, tawfik@marvell.com, thomas.petazzoni@free-electrons.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: mvebu: enable Armada 38x RTC driver in mvebu_v7_defconfig
has been added to the -mm tree.  Its filename is
     arm-mvebu-enable-armada-38x-rtc-driver-in-mvebu_v7_defconfig.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-mvebu-enable-armada-38x-rtc-driver-in-mvebu_v7_defconfig.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-mvebu-enable-armada-38x-rtc-driver-in-mvebu_v7_defconfig.patch

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
Subject: ARM: mvebu: enable Armada 38x RTC driver in mvebu_v7_defconfig

Now that the Armada 38x RTC driver has been pushed, let's enable it in
mvebu_v7_defconfig.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Arnaud Ebalard <arno@natisbad.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Lior Amsalem <alior@marvell.com>
Cc: Tawfik Bayouk <tawfik@marvell.com>
Cc: Nadav Haklai <nadavh@marvell.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/configs/mvebu_v7_defconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/arm/configs/mvebu_v7_defconfig~arm-mvebu-enable-armada-38x-rtc-driver-in-mvebu_v7_defconfig arch/arm/configs/mvebu_v7_defconfig
--- a/arch/arm/configs/mvebu_v7_defconfig~arm-mvebu-enable-armada-38x-rtc-driver-in-mvebu_v7_defconfig
+++ a/arch/arm/configs/mvebu_v7_defconfig
@@ -112,6 +112,7 @@ CONFIG_LEDS_TRIGGER_HEARTBEAT=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_S35390A=y
 CONFIG_RTC_DRV_MV=y
+CONFIG_RTC_DRV_ARMADA38X=y
 CONFIG_DMADEVICES=y
 CONFIG_MV_XOR=y
 # CONFIG_IOMMU_SUPPORT is not set
_

Patches currently in -mm which might be from gregory.clement@free-electrons.com are

rtc-armada38x-add-the-device-tree-binding-documentation.patch
drivers-rtc-rtc-armada38x-add-a-new-rtc-driver-for-recent-mvebu-socs.patch
maintainers-add-the-rtc-driver-for-the-armada38x.patch
arm-mvebu-add-device-tree-description-of-rtc-on-armada-38x.patch
arm-mvebu-enable-armada-38x-rtc-driver-in-mvebu_v7_defconfig.patch
linux-next.patch

