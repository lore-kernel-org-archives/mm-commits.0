From: akpm@linux-foundation.org
Subject: - fixup-s3c24xx-build-after-arch-moves.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:11:18 -0700
Message-ID: <200707290611.l6T6BIrP010974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39825 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757963AbXG2GMK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:12:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     fixup s3c24xx build after arch moves
has been removed from the -mm tree.  Its filename was
     fixup-s3c24xx-build-after-arch-moves.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fixup s3c24xx build after arch moves
From: Ben Dooks <ben-linux@fluff.org>

Fix the include files moved around during the s3c24xx arch moves.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_s3c24xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

origin.patch
s3c2410-fixup-after-arch-moves.patch
s3c2410fb-fix-s3c2410-compilation.patch
git-mtd.patch
git-watchdog.patch
sm501fb-update-suspend-and-resume-code.patch
sm501fb-call-fb-suspend-function-during-suspend-and-resume.patch
sm501fb-ensure-panel-interface-is-not-tristated-when-setup.patch
