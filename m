From: akpm@linux-foundation.org
Subject: - m68k-fix-a-few-hickups-in-drivers-scsi-kconfig.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:56:16 -0700
Message-ID: <200708242056.l7OKuGxu014026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53148 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762651AbXHXVIP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k: Fix a few hickups in drivers/scsi/Kconfig
has been removed from the -mm tree.  Its filename was
     m68k-fix-a-few-hickups-in-drivers-scsi-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: m68k: Fix a few hickups in drivers/scsi/Kconfig
From: Geert Uytterhoeven <geert@linux-m68k.org>

m68k: Fix a few hickups in drivers/scsi/Kconfig

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/Kconfig~m68k-fix-a-few-hickups-in-drivers-scsi-kconfig drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig~m68k-fix-a-few-hickups-in-drivers-scsi-kconfig
+++ a/drivers/scsi/Kconfig
@@ -1561,7 +1561,7 @@ config A3000_SCSI
 	  built-in SCSI controller, say Y. Otherwise, say N.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called wd33c93.
+	  module will be called a3000.
 
 config A2091_SCSI
 	tristate "A2091/A590 WD33C93A support"
@@ -1571,7 +1571,7 @@ config A2091_SCSI
 	  say N.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called wd33c93.
+	  module will be called a2091.
 
 config GVP11_SCSI
 	tristate "GVP Series II WD33C93A support"
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
move-preempt_notifiers-into-an-always-included-kconfig.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
