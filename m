From: akpm@linux-foundation.org
Subject: - gpiolib-fix-typo-in-comment.patch removed from -mm tree
Date: Mon, 28 Jul 2008 14:10:49 -0700
Message-ID: <200807282110.m6SLAnxW027602@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51266 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760978AbYG1VLc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 17:11:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mb@bu3sch.de, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     gpiolib: fix typo in comment
has been removed from the -mm tree.  Its filename was
     gpiolib-fix-typo-in-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpiolib: fix typo in comment
From: Michael Buesch <mb@bu3sch.de>

This fixes an off-by-one error in a comment.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/gpio.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-generic/gpio.h~gpiolib-fix-typo-in-comment include/asm-generic/gpio.h
--- a/include/asm-generic/gpio.h~gpiolib-fix-typo-in-comment
+++ a/include/asm-generic/gpio.h
@@ -13,7 +13,7 @@
  *
  * While the GPIO programming interface defines valid GPIO numbers
  * to be in the range 0..MAX_INT, this library restricts them to the
- * smaller range 0..ARCH_NR_GPIOS.
+ * smaller range 0..ARCH_NR_GPIOS-1.
  */
 
 #ifndef ARCH_NR_GPIOS
_

Patches currently in -mm which might be from mb@bu3sch.de are

origin.patch
spi-add-spi-over-gpio-driver.patch
spi-add-spi-over-gpio-driver-fix-returned-error-code.patch
mmc-add-gpio-based-mmc-sd-driver.patch

