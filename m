From: akpm@linux-foundation.org
Subject: + tridentfb-remove-warning-message-that-cyblafb-driver-should-be-used.patch added to -mm tree
Date: Sun, 20 Jul 2008 18:40:40 -0700
Message-ID: <200807210140.m6L1eeAj011228@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755314AbYGUBlC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 Jul 2008 21:41:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     tridentfb: remove warning message that cyblafb driver should be used
has been added to the -mm tree.  Its filename is
     tridentfb-remove-warning-message-that-cyblafb-driver-should-be-used.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tridentfb: remove warning message that cyblafb driver should be used
From: Krzysztof Helt <krzysztof.h1@wp.pl>

The tridentfb driver should handle now all chipsets handled by the cyblafb
driver.  Remove the message which claims that support will be removed.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/video/tridentfb.c~tridentfb-remove-warning-message-that-cyblafb-driver-should-be-used drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-remove-warning-message-that-cyblafb-driver-should-be-used
+++ a/drivers/video/tridentfb.c
@@ -1359,10 +1359,6 @@ static int __devinit trident_pci_probe(s
 
 	chip_id = id->device;
 
-	if (chip_id == CYBERBLADEi1)
-		output("*** Please do use cyblafb, Cyberblade/i1 support "
-		       "will soon be removed from tridentfb!\n");
-
 #ifndef CONFIG_FB_TRIDENT_ACCEL
 	noaccel = 1;
 #endif
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
tridentfb-replace-macros-with-functions.patch
tridentfb-convert-fb_info-into-allocated-one.patch
tridentfb-move-global-pseudo-palette-into-structure.patch
tridentfb-move-global-chip_id-into-structure.patch
tridentfb-move-global-flat-panel-variable-into-structure.patch
tridentfb-convert-is_blade-and-is_xp-macros-into-functions.patch
tridentfb-move-global-acceleration-hooks-into-structure.patch
tridentfb-make-use-of-functions-and-constants-from-the-vgah.patch
tridentfb-fix-timing-calculations.patch
tridentfb-use-mmio-access-for-clock-setting.patch
tridentfb-fix-clock-settings-for-older-trident-96xx-chips.patch
tridentfb-improve-probe-function.patch
tridentfb-improved-register-values-on-tgui-9680.patch
tridentfb-add-tgui-9440-support.patch
tridentfb-fix-unitialized-pseudo_palette.patch
tridentfb-improve-check_var-function.patch
tridentfb-preserve-memory-type-settings.patch
tridentfb-fix-hi-color-modes-for-tgui-9440.patch
tridentfb-add-acceleration-for-tgui-families.patch
tridentfb-acceleration-code-improvements.patch
tridentfb-acceleration-bug-fixes.patch
tridentfb-various-pixclock-and-timing-improvements.patch
tridentfb-acceleration-constants-change.patch
tridentfb-source-code-improvements.patch
tridentfb-fix-console-freeze-when-switching-from-x11.patch
tridentfb-fix-224-color-logo-at-8-bpp.patch
tridentfb-y-panning-fixes.patch
tridentfb-blade3d-clock-fixes.patch
tridentfb-add-imageblit-acceleration-for-blade3d-family.patch
tridentfb-remove-warning-message-that-cyblafb-driver-should-be-used.patch
amifb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
fbcon-make-logo_height-a-local-variable.patch
uvesafb-change-mode-parameter-to-mode_option.patch
tridentfb-documentation-update.patch
tdfxfb-add-mode_option-module-parameter.patch
vga16fb-source-code-improvement.patch
tdfxfb-remove-ypan-checks-done-by-a-higher-layer.patch
vfb-only-enable-if-explicitly-requested-when-compiled-in.patch
hgafb-convert-to-new-platform-driver-api-bugzilla-9689.patch
skeletonfb-update-to-correct-platform-driver-usage.patch
neofb-simplify-clock-calculation.patch
neofb-drop-redundant-code.patch
neofb-drop-the-xtimings-structure.patch

