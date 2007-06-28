From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-ii-misc-strange-dev-fix.patch removed from -mm tree
Date: Thu, 28 Jun 2007 12:49:53 -0700
Message-ID: <200706281949.l5SJnsvo000303@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52273 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756624AbXF1TuJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jun 2007 15:50:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@computergmbh.de, mm-commits@vger.kernel.org


The patch titled
     use-menuconfig-objects-ii-misc-strange-dev fix
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-ii-misc-strange-dev-fix.patch

This patch was dropped because it causes oldconfig problems

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
fix-gregkh-usb-usb-use-menuconfig-objects.patch
use-menuconfig-objects-ii-auxdisplay-fix.patch
use-menuconfig-objects-ii-misc-strange-dev-fix.patch
use-menuconfig-objects-ii-oprofile-fix.patch
use-menuconfig-objects-crypto-hw-fix.patch
