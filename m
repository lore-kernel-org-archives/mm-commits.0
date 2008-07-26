From: akpm@linux-foundation.org
Subject: + gpiolib-fix-typo-in-comment.patch added to -mm tree
Date: Sat, 26 Jul 2008 12:12:11 -0700
Message-ID: <200807261912.m6QJCBTG015165@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752071AbYGZTMY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 15:12:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mb@bu3sch.de, david-b@pacbell.net


The patch titled
     gpiolib: fix typo in comment
has been added to the -mm tree.  Its filename is
     gpiolib-fix-typo-in-comment.patch

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
gpiolib-fix-typo-in-comment.patch
spi-add-spi-over-gpio-driver.patch
spi-add-spi-over-gpio-driver-fix-returned-error-code.patch
mmc-add-gpio-based-mmc-sd-driver.patch

