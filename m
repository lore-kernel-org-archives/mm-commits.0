From: akpm@linux-foundation.org
Subject: + fixup-s3c24xx-build-after-arch-moves.patch added to -mm tree
Date: Tue, 24 Jul 2007 15:16:00 -0700
Message-ID: <200707242216.l6OMG3kS003667@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56595 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756227AbXGXWQ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 18:16:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, dbrownell@users.sourceforge.net


The patch titled
     fixup s3c24xx build after arch moves
has been added to the -mm tree.  Its filename is
     fixup-s3c24xx-build-after-arch-moves.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fixup s3c24xx build after arch moves
From: Ben Dooks <ben-linux@fluff.org>

Fix the include files moved around during the s3c24xx arch moves.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_s3c24xx.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/spi_s3c24xx.c~fixup-s3c24xx-build-after-arch-moves drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c~fixup-s3c24xx-build-after-arch-moves
+++ a/drivers/spi/spi_s3c24xx.c
@@ -28,7 +28,7 @@
 #include <asm/hardware.h>
 
 #include <asm/arch/regs-gpio.h>
-#include <asm/arch/regs-spi.h>
+#include <asm/plat-s3c24xx/regs-spi.h>
 #include <asm/arch/spi.h>
 
 struct s3c24xx_spi {
_

Patches currently in -mm which might be from ben-linux@fluff.org are

fixup-s3c24xx-build-after-arch-moves.patch
git-mtd.patch
