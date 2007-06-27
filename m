From: akpm@linux-foundation.org
Subject: + use-menuconfig-objects-ii-block-devices-fix.patch added to -mm tree
Date: Wed, 27 Jun 2007 14:14:06 -0700
Message-ID: <200706272114.l5RLE6YA007268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34835 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751600AbXF0VOP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jun 2007 17:14:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jengelh@computergmbh.de


The patch titled
     use-menuconfig-objects-ii-block-devices fix
has been added to the -mm tree.  Its filename is
     use-menuconfig-objects-ii-block-devices-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
