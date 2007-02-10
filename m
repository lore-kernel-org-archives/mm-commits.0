From: akpm@linux-foundation.org
Subject: - avr32-fix-build-breakage.patch removed from -mm tree
Date: Fri, 09 Feb 2007 20:50:55 -0800
Message-ID: <200702100450.l1A4ou7Q003958@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35988 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080AbXBJEvD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 23:51:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben.nizette@iinet.net.au, hskinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     AVR32: fix build breakage
has been removed from the -mm tree.  Its filename was
     avr32-fix-build-breakage.patch

This patch was dropped because the arv32 tree has vanished

------------------------------------------------------
Subject: AVR32: fix build breakage
From: Ben Nizette <ben.nizette@iinet.net.au>

Remove an unwanted remnant of the recent revert of AVR32/AT91 SPI
patches in -mm.  Without this patch, the AVR32 build of
2.6.20-rc[34]-mm1 breaks.

Signed-off-by: Ben Nizette <ben.nizette@iinet.net.au>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/mach-at32ap/at32ap7000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/avr32/mach-at32ap/at32ap7000.c~avr32-fix-build-breakage arch/avr32/mach-at32ap/at32ap7000.c
--- a/arch/avr32/mach-at32ap/at32ap7000.c~avr32-fix-build-breakage
+++ a/arch/avr32/mach-at32ap/at32ap7000.c
@@ -895,7 +895,7 @@ struct clk *at32_clock_list[] = {
 	&macb0_pclk,
 	&macb1_hclk,
 	&macb1_pclk,
-	&atmel_spi0_mck,
+	&atmel_spi0_pclk,
 	&atmel_spi1_pclk,
 	&lcdc0_hclk,
 	&lcdc0_pixclk,
_

Patches currently in -mm which might be from ben.nizette@iinet.net.au are

git-avr32.patch
avr32-fix-build-breakage.patch
