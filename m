From: akpm@linux-foundation.org
Subject: [merged] arm-mmp-add-display-and-fb-support-in-pxa910-defconfig.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:38:17 -0800
Message-ID: <20130222203817.EA0CF31C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:64796 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756764Ab3BVUiT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:38:19 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so103911yhr.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:38:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zzhu3@marvell.com, FlorianSchandinat@gmx.de, cldu@marvell.com, haojian.zhuang@gmail.com, ligq@marvell.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: mmp: add display and fb support in pxa910 defconfig
has been removed from the -mm tree.  Its filename was
     arm-mmp-add-display-and-fb-support-in-pxa910-defconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhou Zhu <zzhu3@marvell.com>
Subject: ARM: mmp: add display and fb support in pxa910 defconfig

Add display and fb support in pxa910 defconfig.
Add tpohvga panel, spi support.
Add logo support.

Signed-off-by: Zhou Zhu <zzhu3@marvell.com>
Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Lisa Du <cldu@marvell.com>
Cc: Guoqing Li <ligq@marvell.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/configs/pxa910_defconfig |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN arch/arm/configs/pxa910_defconfig~arm-mmp-add-display-and-fb-support-in-pxa910-defconfig arch/arm/configs/pxa910_defconfig
--- a/arch/arm/configs/pxa910_defconfig~arm-mmp-add-display-and-fb-support-in-pxa910-defconfig
+++ a/arch/arm/configs/pxa910_defconfig
@@ -42,6 +42,14 @@ CONFIG_SMC91X=y
 # CONFIG_SERIO is not set
 CONFIG_SERIAL_PXA=y
 CONFIG_SERIAL_PXA_CONSOLE=y
+CONFIG_SPI=y
+CONFIG_FB=y
+CONFIG_MMP_DISP=y
+CONFIG_MMP_DISP_CONTROLLER=y
+CONFIG_MMP_SPI=y
+CONFIG_MMP_PANEL_TPOHVGA=y
+CONFIG_MMP_FB=y
+CONFIG_LOGO=y
 # CONFIG_LEGACY_PTYS is not set
 # CONFIG_HW_RANDOM is not set
 # CONFIG_HWMON is not set
_

Patches currently in -mm which might be from zzhu3@marvell.com are

origin.patch

