From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-crypto-hw-fix.patch added to -mm tree
Date: Wed, 27 Jun 2007 14:18:40 -0700
Message-ID: <200706272118.l5RLIedO007342@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48915 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759242AbXF0VSt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jun 2007 17:18:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@computergmbh.de


The patch titled
     use-menuconfig-objects-crypto-hw fix
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-crypto-hw-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
use-menuconfig-objects-ii-block-devices-fix.patch
fix-gregkh-usb-usb-use-menuconfig-objects.patch
use-menuconfig-objects-ii-auxdisplay-fix.patch
use-menuconfig-objects-ii-misc-strange-dev-fix.patch
use-menuconfig-objects-ii-oprofile-fix.patch
use-menuconfig-objects-crypto-hw-fix.patch
