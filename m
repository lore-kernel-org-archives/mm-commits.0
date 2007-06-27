From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-ii-misc-strange-dev-fix.patch added to -mm tree
Date: Wed, 27 Jun 2007 14:17:22 -0700
Message-ID: <200706272117.l5RLHMpl007324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39864 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758756AbXF0VRb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jun 2007 17:17:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@computergmbh.de


The patch titled
     use-menuconfig-objects-ii-misc-strange-dev fix
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-ii-misc-strange-dev-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use-menuconfig-objects-ii-misc-strange-dev fix
From: Jan Engelhardt <jengelh@computergmbh.de>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig |    1 -
 1 files changed, 1 deletion(-)

diff -puN drivers/misc/Kconfig~use-menuconfig-objects-ii-misc-strange-dev-fix drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~use-menuconfig-objects-ii-misc-strange-dev-fix
+++ a/drivers/misc/Kconfig
@@ -4,7 +4,6 @@
 
 menuconfig MISC_STRANGE_DEV
 	bool "Misc devices"
-	default y
 
 if MISC_STRANGE_DEV
 
_

Patches currently in -mm which might be from jengelh@computergmbh.de are

use-menuconfig-objects-ii-scsi-fix.patch
use-menuconfig-objects-ii-block-devices-fix.patch
fix-gregkh-usb-usb-use-menuconfig-objects.patch
use-menuconfig-objects-ii-auxdisplay-fix.patch
use-menuconfig-objects-ii-misc-strange-dev-fix.patch
