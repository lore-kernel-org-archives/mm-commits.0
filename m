From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-ii-oprofile-fix.patch added to -mm tree
Date: Wed, 27 Jun 2007 14:18:09 -0700
Message-ID: <200706272118.l5RLI96u007336@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37519 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758756AbXF0VSS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jun 2007 17:18:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@computergmbh.de


The patch titled
     use-menuconfig-objects-ii-oprofile fix
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-ii-oprofile-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
use-menuconfig-objects-ii-block-devices-fix.patch
fix-gregkh-usb-usb-use-menuconfig-objects.patch
use-menuconfig-objects-ii-auxdisplay-fix.patch
use-menuconfig-objects-ii-misc-strange-dev-fix.patch
use-menuconfig-objects-ii-oprofile-fix.patch
