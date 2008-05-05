From: akpm@linux-foundation.org
Subject: + arm-lubbock-fix-compilation.patch added to -mm tree
Date: Mon, 05 May 2008 14:01:59 -0700
Message-ID: <200805052101.m45L1xiJ004816@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754908AbYEEVCS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 17:02:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, rmk@arm.linux.org.uk


The patch titled
     arm-lubbock: fix compilation
has been added to the -mm tree.  Its filename is
     arm-lubbock-fix-compilation.patch

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
Subject: arm-lubbock: fix compilation
From: Alexey Dobriyan <adobriyan@gmail.com>

arch/arm/mach-pxa/lubbock.c:399: error: expected '}' before ';' token

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-pxa/lubbock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/mach-pxa/lubbock.c~arm-lubbock-fix-compilation arch/arm/mach-pxa/lubbock.c
--- a/arch/arm/mach-pxa/lubbock.c~arm-lubbock-fix-compilation
+++ a/arch/arm/mach-pxa/lubbock.c
@@ -396,7 +396,7 @@ static struct pxafb_mach_info sharp_lm8v
 	.cmap_inverse	= 0,
 	.cmap_static	= 0,
 	.lcd_conn	= LCD_COLOR_DSTN_16BPP | LCD_PCLK_EDGE_FALL |
-			  LCD_AC_BIAS_FREQ(255);
+			  LCD_AC_BIAS_FREQ(255),
 };
 
 #define	MMC_POLL_RATE		msecs_to_jiffies(1000)
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
arm-lubbock-fix-compilation.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

