From: akpm@linux-foundation.org
Subject: + n770-enable-lcd-mipi-dcs-in-kconfig.patch added to -mm tree
Date: Wed, 24 Jun 2009 17:08:05 -0700
Message-ID: <200906250008.n5P085Id004883@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755303AbZFYAKT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jun 2009 20:10:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: imre.deak@nokia.com, krzysztof.h1@wp.pl


The patch titled
     N770: enable LCD MIPI-DCS in Kconfig
has been added to the -mm tree.  Its filename is
     n770-enable-lcd-mipi-dcs-in-kconfig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: N770: enable LCD MIPI-DCS in Kconfig
From: Imre Deak <imre.deak@nokia.com>

Signed-off-by: Imre Deak <imre.deak@nokia.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/configs/n770_defconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/configs/n770_defconfig~n770-enable-lcd-mipi-dcs-in-kconfig arch/arm/configs/n770_defconfig
--- a/arch/arm/configs/n770_defconfig~n770-enable-lcd-mipi-dcs-in-kconfig
+++ a/arch/arm/configs/n770_defconfig
@@ -875,7 +875,7 @@ CONFIG_FB_OMAP_LCDC_EXTERNAL=y
 CONFIG_FB_OMAP_LCDC_HWA742=y
 # CONFIG_FB_OMAP_LCDC_BLIZZARD is not set
 CONFIG_FB_OMAP_MANUAL_UPDATE=y
-# CONFIG_FB_OMAP_LCD_MIPID is not set
+CONFIG_FB_OMAP_LCD_MIPID=y
 # CONFIG_FB_OMAP_BOOTLOADER_INIT is not set
 CONFIG_FB_OMAP_CONSISTENT_DMA_SIZE=2
 # CONFIG_FB_OMAP_DMA_TUNE is not set
_

Patches currently in -mm which might be from imre.deak@nokia.com are

origin.patch
linux-next.patch
omapfb-add-support-for-the-apollon-lcd.patch
omapfb-add-support-for-mipi-dcs-compatible-lcds.patch
omapfb-add-support-for-the-amstrad-delta-lcd.patch
omapfb-add-support-for-the-2430sdp-lcd.patch
omapfb-add-support-for-the-omap2evm-lcd.patch
omapfb-add-support-for-the-3430sdp-lcd.patch
omapfb-add-support-for-the-omap3-evm-lcd.patch
omapfb-add-support-for-the-omap3-beagle-dvi-output.patch
omapfb-add-support-for-the-gumstix-overo-lcd.patch
omapfb-add-support-for-the-zoom-mdk-lcd.patch
omapfb-add-support-for-rotation-on-the-blizzard-lcd-ctrl.patch
n770-enable-lcd-mipi-dcs-in-kconfig.patch
omapfb-dispc-various-typo-fixes.patch
omapfb-dispc-disable-iface-clocks-along-with-func-clocks.patch
omapfb-dispc-enable-wake-up-capability.patch
omapfb-dispc-allow-multiple-external-irq-handlers.patch
omapfb-suspend-resume-only-if-fb-device-is-already-initialized.patch
omapfb-fix-coding-style-remove-dead-line.patch
omapfb-add-fb-manual-update-option-to-kconfig.patch
omapfb-hwa742-fix-pointer-to-be-const.patch

