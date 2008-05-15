From: akpm@linux-foundation.org
Subject: + fix-parenthesis-in-include-asm-mips-mach-au1x00-au1000h.patch added to -mm tree
Date: Thu, 15 May 2008 11:55:02 -0700
Message-ID: <200805151855.m4FIt2R2005253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41864 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751874AbYEOSzo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 14:55:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, ralf@linux-mips.org


The patch titled
     fix parenthesis in include/asm-mips/mach-au1x00/au1000.h
has been added to the -mm tree.  Its filename is
     fix-parenthesis-in-include-asm-mips-mach-au1x00-au1000h.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix parenthesis in include/asm-mips/mach-au1x00/au1000.h
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Parenthesis fix in include/asm-mips/mach-au1x00/au1000.h

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mips/mach-au1x00/au1000.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-mips/mach-au1x00/au1000.h~fix-parenthesis-in-include-asm-mips-mach-au1x00-au1000h include/asm-mips/mach-au1x00/au1000.h
--- a/include/asm-mips/mach-au1x00/au1000.h~fix-parenthesis-in-include-asm-mips-mach-au1x00-au1000h
+++ a/include/asm-mips/mach-au1x00/au1000.h
@@ -1036,7 +1036,7 @@ enum soc_au1200_ints {
 #define USBD_INTSTAT		0xB020001C
 #  define USBDEV_INT_SOF	(1 << 12)
 #  define USBDEV_INT_HF_BIT	6
-#  define USBDEV_INT_HF_MASK	0x3f << USBDEV_INT_HF_BIT)
+#  define USBDEV_INT_HF_MASK	(0x3f << USBDEV_INT_HF_BIT)
 #  define USBDEV_INT_CMPLT_BIT	0
 #  define USBDEV_INT_CMPLT_MASK (0x3f << USBDEV_INT_CMPLT_BIT)
 #define USBD_CONFIG		0xB0200020
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

linux-next.patch
fix-parenthesis-in-include-asm-arm-arch-omap-controlh.patch
fix-parenthesis-in-include-asm-mips-gich.patch
fix-parenthesis-in-include-asm-mips-mach-au1x00-au1000h.patch
reiser4.patch

