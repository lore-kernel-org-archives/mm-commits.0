From: akpm@linux-foundation.org
Subject: + arm-mmp-add-display-and-fb-support-in-pxa910-defconfig.patch added to -mm tree
Date: Fri, 01 Feb 2013 15:36:31 -0800
Message-ID: <20130201233632.34B4431C1BF@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:55616 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756458Ab3BAXgd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Feb 2013 18:36:33 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so499096vbi.5
        for <mm-commits@vger.kernel.org>; Fri, 01 Feb 2013 15:36:32 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zzhu3@marvell.com, FlorianSchandinat@gmx.de, cldu@marvell.com, haojian.zhuang@gmail.com, ligq@marvell.com


The patch titled
     Subject: ARM: mmp: add display and fb support in pxa910 defconfig
has been added to the -mm tree.  Its filename is
     arm-mmp-add-display-and-fb-support-in-pxa910-defconfig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

video-mmp-display-subsystem.patch
video-mmp-fb-support.patch
video-mmp-display-controller-support.patch
video-mmp-add-tpo-hvga-panel-supported.patch
video-mmpdisp-add-spi-port-in-display-controller.patch
arm-mmp-added-device-for-display-controller.patch
arm-mmp-enable-display-in-ttc_dkb.patch
arm-mmp-add-display-and-fb-support-in-pxa910-defconfig.patch

