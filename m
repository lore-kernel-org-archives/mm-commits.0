From: akpm@linux-foundation.org
Subject: + spelling-fix-weired-weird.patch added to -mm tree
Date: Thu, 13 Sep 2007 15:04:06 -0700
Message-ID: <200709132204.l8DM46kV008179@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33626 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758123AbXIMWEO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 18:04:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org


The patch titled
     Spelling fix: weired -> weird
has been added to the -mm tree.  Its filename is
     spelling-fix-weired-weird.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Spelling fix: weired -> weird
From: Ralf Baechle <ralf@linux-mips.org>

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/scsi/ibmmca.txt |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/scsi/ibmmca.txt~spelling-fix-weired-weird Documentation/scsi/ibmmca.txt
--- a/Documentation/scsi/ibmmca.txt~spelling-fix-weired-weird
+++ a/Documentation/scsi/ibmmca.txt
@@ -1188,7 +1188,7 @@
 	and 15 get ignored by the driver & adapter!
      Q: I have a 9595 and I get a NMI during heavy SCSI I/O e.g. during fsck.
         A COMMAND ERROR is reported and characters on the screen are missing.
-	Warm reboot is not possible. Things look like quite weired.
+	Warm reboot is not possible. Things look like quite weird.
      A: Check the processor type of your 9595. If you have an 80486 or 486DX-2
         processor complex on your mainboard and you compiled a kernel that
 	supports 80386 processors, it is possible, that the kernel cannot
_

Patches currently in -mm which might be from ralf@linux-mips.org are

bcm1480-serial-build-fix.patch
git-input.patch
git-mips.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-add-gpio-support-to-the-bcm947xx-platform-update.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
mips-move-platform-independent-cfe-code-into-arch-mips-cfe.patch
mips-add-cfe-support-to-bcm947xx-code.patch
mips-replace-config_usb_ohci-with-config_usb_ohci_hcd-in-a-few-overlooked-files.patch
git-mtd.patch
git-netdev-all.patch
remove-setup-of-platform-device-from-jazzsonicc.patch
sgiseeq-replace-use-of-dma_cache_wback_inv.patch
move-a-few-definitions-to-au1000_xxs1500c.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
serial_txx9-cleanup-includes.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
clean-up-duplicate-includes-in-drivers-char.patch
spelling-fix-weired-weird.patch
rtc-make-rtc-ds1742-driver-hotplug-aware-take-2.patch
fbcon-convert-struct-font_desc-to-use-iso-c-initializers.patch
fbcon-convert-struct-font_desc-to-use-iso-c-initializers-update.patch
vt-fix-warnings-in-selectionh.patch
add-a-00-index-file-to-documentation-mips.patch
define-global-bit-macro.patch
bitops-introduce-lock-ops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
