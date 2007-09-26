From: akpm@linux-foundation.org
Subject: + fix-wrong-filename-reference-in-drivers-testingtxt.patch added to -mm tree
Date: Wed, 26 Sep 2007 15:35:26 -0700
Message-ID: <200709262235.l8QMZQv6007377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46541 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760824AbXIZWfh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 18:35:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org


The patch titled
     Fix wrong filename reference in drivers-testing.txt
has been added to the -mm tree.  Its filename is
     fix-wrong-filename-reference-in-drivers-testingtxt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix wrong filename reference in drivers-testing.txt
From: Ralf Baechle <ralf@linux-mips.org>

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/power/drivers-testing.txt~fix-wrong-filename-reference-in-drivers-testingtxt Documentation/power/drivers-testing.txt
--- a/Documentation/power/drivers-testing.txt~fix-wrong-filename-reference-in-drivers-testingtxt
+++ a/Documentation/power/drivers-testing.txt
@@ -14,8 +14,8 @@ the machine's BIOS.
 Of course, for this purpose the test system has to be known to suspend and
 resume without the driver being tested.  Thus, if possible, you should first
 resolve all suspend/resume-related problems in the test system before you start
-testing the new driver.  Please see Documents/power/basic-pm-debugging.txt for
-more information about the debugging of suspend/resume functionality.
+testing the new driver.  Please see Documentation/power/basic-pm-debugging.txt
+for more information about the debugging of suspend/resume functionality.
 
 2. Testing the driver
 
_

Patches currently in -mm which might be from ralf@linux-mips.org are

git-mips.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-replace-config_usb_ohci-with-config_usb_ohci_hcd-in-a-few-overlooked-files.patch
git-mtd.patch
git-net.patch
move-a-few-definitions-to-au1000_xxs1500c.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
serial_txx9-cleanup-includes.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
clean-up-duplicate-includes-in-drivers-char.patch
spelling-fix-weired-weird.patch
remove-dma_cache_wbackinvwback_inv-functions.patch
lk201-remove-obsolete-driver.patch
fix-wrong-filename-reference-in-drivers-testingtxt.patch
rtc-make-rtc-ds1742-driver-hotplug-aware-take-2.patch
fbcon-convert-struct-font_desc-to-use-iso-c-initializers.patch
fbcon-convert-struct-font_desc-to-use-iso-c-initializers-update.patch
vt-fix-warnings-in-selectionh.patch
export-font_vga_8x16.patch
drivers-video-pmag-ba-fbc-improve-diagnostics.patch
drivers-video-pmag-ba-fbc-improve-diagnostics-fix.patch
add-a-00-index-file-to-documentation-mips.patch
define-global-bit-macro.patch
bitops-introduce-lock-ops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
