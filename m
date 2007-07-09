From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-ii-auxdisplay-fix.patch removed from -mm tree
Date: Mon, 09 Jul 2007 14:44:15 -0700
Message-ID: <200707092144.l69LiF5D013863@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52668 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755158AbXGIVoZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 17:44:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@computergmbh.de, mm-commits@vger.kernel.org


The patch titled
     use-menuconfig-objects-ii-auxdisplay fix
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-ii-auxdisplay-fix.patch

This patch was dropped because it was folded into use-menuconfig-objects-ii-auxdisplay.patch

------------------------------------------------------
Subject: use-menuconfig-objects-ii-auxdisplay fix
From: Jan Engelhardt <jengelh@computergmbh.de>


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/auxdisplay/Kconfig |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/auxdisplay/Kconfig~use-menuconfig-objects-ii-auxdisplay-fix drivers/auxdisplay/Kconfig
--- a/drivers/auxdisplay/Kconfig~use-menuconfig-objects-ii-auxdisplay-fix
+++ a/drivers/auxdisplay/Kconfig
@@ -8,9 +8,8 @@
 menuconfig AUXDISPLAY
 	depends on PARPORT
 	bool "Auxiliary Display support"
-	default y
 
-if AUXDISPLAY
+if AUXDISPLAY && PARPORT
 
 config KS0108
 	tristate "KS0108 LCD Controller"
_

Patches currently in -mm which might be from jengelh@computergmbh.de are

fix-gregkh-usb-usb-use-menuconfig-objects.patch
use-menuconfig-objects-ii-auxdisplay.patch
use-menuconfig-objects-ii-auxdisplay-fix.patch
