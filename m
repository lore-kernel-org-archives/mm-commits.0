From: akpm@linux-foundation.org
Subject: - misc-phantom-add-comment-about-openhaptics.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:52:22 -0700
Message-ID: <200710192252.l9JMqM8J024264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56182 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763913AbXJSXFM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:05:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Misc: phantom, add comment about openhaptics
has been removed from the -mm tree.  Its filename was
     misc-phantom-add-comment-about-openhaptics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Misc: phantom, add comment about openhaptics
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/phantom.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/misc/phantom.c~misc-phantom-add-comment-about-openhaptics drivers/misc/phantom.c
--- a/drivers/misc/phantom.c~misc-phantom-add-comment-about-openhaptics
+++ a/drivers/misc/phantom.c
@@ -9,6 +9,7 @@
  *  You need an userspace library to cooperate with this driver. It (and other
  *  info) may be obtained here:
  *  http://www.fi.muni.cz/~xslaby/phantom.html
+ *  or alternatively, you might use OpenHaptics provided by Sensable.
  */
 
 #include <linux/kernel.h>
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
v4l-stk11xx-add-a-new-webcam-driver.patch
v4l-stk11xx-use-array_size-in-another-2-cases.patch
v4l-stk11xx-use-retval-from-stk11xx_check_device.patch
v4l-stk11xx-add-static-to-tables.patch
git-wireless.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
remove-asm-bitopsh-includes-reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
