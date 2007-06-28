From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-ii-block-devices-fix.patch removed from -mm tree
Date: Thu, 28 Jun 2007 12:10:44 -0700
Message-ID: <200706281910.l5SJAit6032117@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55204 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752135AbXF1TKz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jun 2007 15:10:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@computergmbh.de, mm-commits@vger.kernel.org


The patch titled
     use-menuconfig-objects-ii-block-devices fix
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-ii-block-devices-fix.patch

This patch was dropped because it causes oldconfig pain

------------------------------------------------------
Subject: use-menuconfig-objects-ii-block-devices fix
From: Jan Engelhardt <jengelh@computergmbh.de>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/Kconfig |    1 -
 1 files changed, 1 deletion(-)

diff -puN drivers/block/Kconfig~use-menuconfig-objects-ii-block-devices-fix drivers/block/Kconfig
--- a/drivers/block/Kconfig~use-menuconfig-objects-ii-block-devices-fix
+++ a/drivers/block/Kconfig
@@ -5,7 +5,6 @@
 menuconfig BLK_DEV
 	bool "Block devices"
 	depends on BLOCK
-	default y
 
 if BLK_DEV
 
_

Patches currently in -mm which might be from jengelh@computergmbh.de are

use-menuconfig-objects-ii-scsi-fix.patch
use-menuconfig-objects-ii-block-devices-fix.patch
fix-gregkh-usb-usb-use-menuconfig-objects.patch
use-menuconfig-objects-ii-auxdisplay-fix.patch
use-menuconfig-objects-ii-misc-strange-dev-fix.patch
use-menuconfig-objects-ii-oprofile-fix.patch
use-menuconfig-objects-crypto-hw-fix.patch
