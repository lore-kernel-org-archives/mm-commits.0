From: akpm@linux-foundation.org
Subject: [folded] fbdev-s1d13xxxfb-add-accelerated-bitblt-functions-fix.patch removed from -mm tree
Date: Tue, 16 Jun 2009 15:09:44 -0700
Message-ID: <200906162209.n5GM9ixY005783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50098 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753800AbZFPWJt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 18:09:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristoffer.ericson@gmail.com, krzysztof.h1@poczta.fm, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fbdev-s1d13xxxfb-add-accelerated-bitblt-functions-fix
has been removed from the -mm tree.  Its filename was
     fbdev-s1d13xxxfb-add-accelerated-bitblt-functions-fix.patch

This patch was dropped because it was folded into fbdev-s1d13xxxfb-add-accelerated-bitblt-functions.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev-s1d13xxxfb-add-accelerated-bitblt-functions-fix
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>

Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/video/s1d13xxxfb.h |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN include/video/s1d13xxxfb.h~fbdev-s1d13xxxfb-add-accelerated-bitblt-functions-fix include/video/s1d13xxxfb.h
--- a/include/video/s1d13xxxfb.h~fbdev-s1d13xxxfb-add-accelerated-bitblt-functions-fix
+++ a/include/video/s1d13xxxfb.h
@@ -136,6 +136,15 @@
 #define S1DREG_DELAYOFF			0xFFFE
 #define S1DREG_DELAYON			0xFFFF
 
+#define BBLT_FIFO_EMPTY			0x00
+#define BBLT_FIFO_NOT_EMPTY		0x40
+#define BBLT_FIFO_NOT_FULL		0x30
+#define BBLT_FIFO_HALF_FULL		0x20
+#define BBLT_FIFO_FULL			0x10
+
+#define BBLT_SOLID_FILL			0x0c
+
+
 /* Note: all above defines should go in separate header files
    when implementing other S1D13xxx chip support. */
 
_

Patches currently in -mm which might be from kristoffer.ericson@gmail.com are

fbdev-s1d13xxxfb-add-accelerated-bitblt-functions.patch
fbdev-s1d13xxxfb-add-accelerated-bitblt-functions-fix.patch

