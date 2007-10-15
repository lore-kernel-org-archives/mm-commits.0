From: akpm@linux-foundation.org
Subject: + jazzsonic-fix-warning-about-unused-variable.patch added to -mm tree
Date: Mon, 15 Oct 2007 16:13:50 -0700
Message-ID: <200710152313.l9FNDokS030269@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51070 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753938AbXJOXOg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 19:14:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org


The patch titled
     Jazzsonic: Fix warning about unused variable.
has been added to the -mm tree.  Its filename is
     jazzsonic-fix-warning-about-unused-variable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Jazzsonic: Fix warning about unused variable.
From: Ralf Baechle <ralf@linux-mips.org>

Caused by "[NET]: Introduce and use print_mac() and DECLARE_MAC_BUF()"
aka 0795af5729b18218767fab27c44b1384f72dc9ad.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/jazzsonic.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/net/jazzsonic.c~jazzsonic-fix-warning-about-unused-variable drivers/net/jazzsonic.c
--- a/drivers/net/jazzsonic.c~jazzsonic-fix-warning-about-unused-variable
+++ a/drivers/net/jazzsonic.c
@@ -208,7 +208,6 @@ static int __init jazz_sonic_probe(struc
 	struct sonic_local *lp;
 	struct resource *res;
 	int err = 0;
-	int i;
 	DECLARE_MAC_BUF(mac);
 
 	dev = alloc_etherdev(sizeof(struct sonic_local));
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
add-assembler-equivalents-to-__initdate_refok.patch
git-mips.patch
jazzsonic-fix-warning-about-unused-variable.patch
move-a-few-definitions-to-au1000_xxs1500c.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
serial_txx9-cleanup-includes.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
clean-up-duplicate-includes-in-drivers-char.patch
spelling-fix-weired-weird.patch
remove-dma_cache_wbackinvwback_inv-functions.patch
lk201-remove-obsolete-driver.patch
fix-wrong-filename-reference-in-drivers-testingtxt.patch
completely-remove-deprecated-irq-flags-sa_.patch
compile-handle_percpu_irq-even-for-uniprocessor-kernels.patch
break-elf_platform-and-stack-pointer-randomization-dependency.patch
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
replace-__attribute_pure__-with-__pure.patch
