From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-crypto-hw-fix.patch removed from -mm tree
Date: Thu, 28 Jun 2007 12:50:41 -0700
Message-ID: <200706281950.l5SJogFK000311@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36942 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760123AbXF1Tuv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jun 2007 15:50:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@computergmbh.de, mm-commits@vger.kernel.org


The patch titled
     use-menuconfig-objects-crypto-hw fix
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-crypto-hw-fix.patch

This patch was dropped because it causes oldconfig problems

------------------------------------------------------
Subject: use-menuconfig-objects-crypto-hw fix
From: Jan Engelhardt <jengelh@computergmbh.de>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/crypto/Kconfig |    1 -
 1 files changed, 1 deletion(-)

diff -puN drivers/crypto/Kconfig~use-menuconfig-objects-crypto-hw-fix drivers/crypto/Kconfig
--- a/drivers/crypto/Kconfig~use-menuconfig-objects-crypto-hw-fix
+++ a/drivers/crypto/Kconfig
@@ -1,7 +1,6 @@
 
 menuconfig CRYPTO_HW
 	bool "Hardware crypto devices"
-	default y
 
 if CRYPTO_HW
 
_

Patches currently in -mm which might be from jengelh@computergmbh.de are

use-menuconfig-objects-ii-scsi-fix.patch
fix-gregkh-usb-usb-use-menuconfig-objects.patch
use-menuconfig-objects-ii-auxdisplay-fix.patch
use-menuconfig-objects-crypto-hw-fix.patch
