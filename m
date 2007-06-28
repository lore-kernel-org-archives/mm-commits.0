From: akpm@linux-foundation.org
Subject: - use-menuconfig-objects-ii-oprofile-fix.patch removed from -mm tree
Date: Thu, 28 Jun 2007 12:50:27 -0700
Message-ID: <200706281950.l5SJoSBn000308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54281 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759687AbXF1Tuh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jun 2007 15:50:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@computergmbh.de, mm-commits@vger.kernel.org


The patch titled
     use-menuconfig-objects-ii-oprofile fix
has been removed from the -mm tree.  Its filename was
     use-menuconfig-objects-ii-oprofile-fix.patch

This patch was dropped because it causes oldconfig problems

------------------------------------------------------
Subject: use-menuconfig-objects-ii-oprofile fix
From: Jan Engelhardt <jengelh@computergmbh.de>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig |    1 -
 1 files changed, 1 deletion(-)

diff -puN arch/i386/Kconfig~use-menuconfig-objects-ii-oprofile-fix arch/i386/Kconfig
--- a/arch/i386/Kconfig~use-menuconfig-objects-ii-oprofile-fix
+++ a/arch/i386/Kconfig
@@ -1234,7 +1234,6 @@ source "fs/Kconfig"
 menuconfig INSTRUMENTATION
 	bool "Instrumentation Support"
 	depends on EXPERIMENTAL
-	default y
 
 if INSTRUMENTATION
 
_

Patches currently in -mm which might be from jengelh@computergmbh.de are

use-menuconfig-objects-ii-scsi-fix.patch
fix-gregkh-usb-usb-use-menuconfig-objects.patch
use-menuconfig-objects-ii-auxdisplay-fix.patch
use-menuconfig-objects-ii-oprofile-fix.patch
use-menuconfig-objects-crypto-hw-fix.patch
