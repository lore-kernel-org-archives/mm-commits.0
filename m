From: akpm@linux-foundation.org
Subject: + uvesafb-change-mode-parameter-to-mode_option.patch added to -mm tree
Date: Tue, 27 May 2008 16:12:32 -0700
Message-ID: <200805272312.m4RNCWh6017950@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58749 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750838AbYE0XMf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 19:12:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     uvesafb: change mode parameter to mode_option
has been added to the -mm tree.  Its filename is
     uvesafb-change-mode-parameter-to-mode_option.patch

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
Subject: uvesafb: change mode parameter to mode_option
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Make more drivers use the "mode_option" parameter.  This one is quite new
so drop the old "mode" parameter before someone starts using it seriously.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/uvesafb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/uvesafb.c~uvesafb-change-mode-parameter-to-mode_option drivers/video/uvesafb.c
--- a/drivers/video/uvesafb.c~uvesafb-change-mode-parameter-to-mode_option
+++ a/drivers/video/uvesafb.c
@@ -2054,8 +2054,8 @@ MODULE_PARM_DESC(maxhf,
 module_param(maxvf, ushort, 0);
 MODULE_PARM_DESC(maxvf,
 	"Maximum vertical frequency [Hz], overrides EDID data");
-module_param_named(mode, mode_option, charp, 0);
-MODULE_PARM_DESC(mode,
+module_param(mode_option, charp, 0);
+MODULE_PARM_DESC(mode_option,
 	"Specify initial video mode as \"<xres>x<yres>[-<bpp>][@<refresh>]\"");
 module_param(vbemode, ushort, 0);
 MODULE_PARM_DESC(vbemode,
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

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
amifb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
fbcon-make-logo_height-a-local-variable.patch
uvesafb-change-mode-parameter-to-mode_option.patch

