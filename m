From: akpm@linux-foundation.org
Subject: + m68k-fix-a-few-hickups-in-drivers-scsi-kconfig.patch added to -mm tree
Date: Wed, 15 Aug 2007 14:18:24 -0700
Message-ID: <200708152118.l7FLIOu8015484@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60792 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933593AbXHOVUz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 17:20:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org


The patch titled
     m68k: Fix a few hickups in drivers/scsi/Kconfig
has been added to the -mm tree.  Its filename is
     m68k-fix-a-few-hickups-in-drivers-scsi-kconfig.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

m68k-asm-pageh-needs-linux-compilerh.patch
m68k-kill-superfluous-extern.patch
m68k-remove-unnecessary-m68k_memoffset-export-and-init.patch
remove-dead-code-in-via-pmu68k.patch
m68k-use-_ac-instead-of-ifdef-__assembly__.patch
m68k-enable-arbitary-speed-tty-support.patch
m68k-dont-include-rodata-into-text-segment.patch
m68k-fix-a-few-hickups-in-drivers-scsi-kconfig.patch
zorro-make-sysfs-config-attribute-read-only.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons-declaration-visible.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
