From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-ii-auxdisplay-fix.patch added to -mm tree
Date: Wed, 27 Jun 2007 14:16:11 -0700
Message-ID: <200706272116.l5RLGBvs007291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55744 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758477AbXF0VQU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jun 2007 17:16:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@computergmbh.de


The patch titled
     use-menuconfig-objects-ii-auxdisplay fix
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-ii-auxdisplay-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

use-menuconfig-objects-ii-scsi-fix.patch
use-menuconfig-objects-ii-block-devices-fix.patch
fix-gregkh-usb-usb-use-menuconfig-objects.patch
use-menuconfig-objects-ii-auxdisplay-fix.patch
