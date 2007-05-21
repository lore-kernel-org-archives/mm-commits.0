From: akpm@linux-foundation.org
Subject: + arm-at91_adc-parenthesis-balance.patch added to -mm tree
Date: Sun, 20 May 2007 20:09:12 -0700
Message-ID: <200705210309.l4L39BuZ001289@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37154 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754338AbXEUDK1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 May 2007 23:10:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl


The patch titled
     arm: at91_adc parenthesis balance
has been added to the -mm tree.  Its filename is
     arm-at91_adc-parenthesis-balance.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: arm: at91_adc parenthesis balance
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

unbalanced parenthesis macro fix.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-arm/arch-at91/at91_adc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-arm/arch-at91/at91_adc.h~arm-at91_adc-parenthesis-balance include/asm-arm/arch-at91/at91_adc.h
--- a/include/asm-arm/arch-at91/at91_adc.h~arm-at91_adc-parenthesis-balance
+++ a/include/asm-arm/arch-at91/at91_adc.h
@@ -55,7 +55,7 @@
 #define AT91_ADC_IDR		0x28		/* Interrupt Disable Register */
 #define AT91_ADC_IMR		0x2C		/* Interrupt Mask Register */
 
-#define AT91_ADC_CHR(n)		(0x30 + ((n) * 4)	/* Channel Data Register N */
+#define AT91_ADC_CHR(n)		(0x30 + ((n) * 4))	/* Channel Data Register N */
 #define		AT91_ADC_DATA		(0x3ff)
 
 #endif
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

arm-at91_adc-parenthesis-balance.patch
