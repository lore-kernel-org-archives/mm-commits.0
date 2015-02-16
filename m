From: akpm@linux-foundation.org
Subject: [merged]
 arm-mvebu-enable-armada-38x-rtc-driver-in-mvebu_v7_defconfig.patch removed
 from -mm tree
Date: Mon, 16 Feb 2015 12:19:36 -0800
Message-ID: <54e250d8.dMeEDoiYecLSSfFg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbbBPUUN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:20:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gregory.clement@free-electrons.com, a.zummo@towertech.it, alior@marvell.com, andrew@lunn.ch, arno@natisbad.org, boris.brezillon@free-electrons.com, ezequiel.garcia@free-electrons.com, jason@lakedaemon.net, mark.rutland@arm.com, maxime.ripard@free-electrons.com, nadavh@marvell.com, sebastian.hesselbarth@gmail.com, tawfik@marvell.com, thomas.petazzoni@free-electrons.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: mvebu: enable Armada 38x RTC driver in mvebu_v7_defconfig
has been removed from the -mm tree.  Its filename was
     arm-mvebu-enable-armada-38x-rtc-driver-in-mvebu_v7_defconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

