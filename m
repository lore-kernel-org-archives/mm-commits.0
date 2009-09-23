From: akpm@linux-foundation.org
Subject: [merged] n770-enable-lcd-mipi-dcs-in-kconfig.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:00:34 -0700
Message-ID: <200909232000.n8NK0YDC013399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753860AbZIWUBE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:01:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: imre.deak@nokia.com, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     N770: enable LCD MIPI-DCS in Kconfig
has been removed from the -mm tree.  Its filename was
     n770-enable-lcd-mipi-dcs-in-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

