From: akpm@linux-foundation.org
Subject: - cirrusfb-checkpatchpl-cleanup-ppc-fix.patch removed from -mm tree
Date: Mon, 15 Oct 2007 22:01:22 -0700
Message-ID: <200710160501.l9G51Md5010045@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53229 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756526AbXJPFBe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 01:01:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@pol.net, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch.pl cleanup PPC fix
has been removed from the -mm tree.  Its filename was
     cirrusfb-checkpatchpl-cleanup-ppc-fix.patch

This patch was dropped because it was folded into cirrusfb-checkpatchpl-cleanup.patch

------------------------------------------------------
Subject: checkpatch.pl cleanup PPC fix
From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch fixes the error spotted by Geert Uytterhoeven in the "cirrusfb:
checkpatch.pl cleanup" patch.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-checkpatchpl-cleanup-ppc-fix drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-checkpatchpl-cleanup-ppc-fix
+++ a/drivers/video/cirrusfb.c
@@ -59,7 +59,7 @@
 #endif
 #ifdef CONFIG_PPC_PREP
 #include <asm/machdep.h>
-#define isPReP(machine_is(prep))
+#define isPReP machine_is(prep)
 #else
 #define isPReP 0
 #endif
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
pm3fb-copyarea-and-partial-imageblit-suppor.patch
skeletonfb-wrong-field-name-fix.patch
pm3fb-header-file-reduction.patch
pm3fb-imageblit-improved.patch
pm3fb-3-small-fixes.patch
pm3fb-improvements-and-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option.patch
pm2fb-accelerated-imageblit.patch
pm2fb-source-code-improvements.patch
pm2fb-permedia-2v-initialization-fixes.patch
pm2fb-accelerated-24-bit-fillrect.patch
tridentfb-coding-style-improvement.patch
tdfxfb-coding-style-improvement.patch
tdfxfb-3-fixes.patch
tdfxfb-palette-fixes.patch
tdfxfb-code-improvements.patch
tdfxfb-hardware-cursor.patch
tdfxfb-mtrr-support.patch
pm2fb-checkpatch-fixes.patch
pm3fb-checkpatch-fixes.patch
pm2fb-permedia-2v-hardware-cursor-support.patch
pm3fb-hardware-cursor-support.patch
s3c2410fb-code-cleanup.patch
s3c2410fb-remove-fb_info-pointer-from-s3c2410fb_info.patch
s3c2410fb-multi-display-support.patch
s3c2410fb-add-margin-fields-to-s3c2410fb_display.patch
s3c2410fb-use-new-margin-fields.patch
s3c2410fb-remove-lcdcon3-register-from-s3c2410fb_display.patch
s3c2410fb-add-vertical-margins-fields-to-s3c2410fb_display.patch
s3c2410fb-use-vertical-margins-values.patch
s3c2410fb-add-pulse-length-fields-to-s3c2410fb_display.patch
s3c2410fb-remove-lcdcon2-and-lcdcon3-register-fields.patch
s3c2410fb-fix-missing-registers-offset.patch
s3c2410fb-byte-ordering-fixes.patch
fbdev-change-asm-uaccessh-to-linux-uaccessh.patch
s3c2410fb-source-code-improvements.patch
s3c2410fb-adds-pixclock-to-s3c2410fb_display.patch
s3c2410fb-removes-lcdcon1-register-value-from-s3c2410fb_display.patch
s3c2410fb-make-use-of-default_display-settings.patch
cirrusfb-checkpatchpl-cleanup.patch
cirrusfb-checkpatchpl-cleanup-ppc-fix.patch
cirrusfb-remove-typedefs.patch
cirrusfb-remove-fields-from-cirrusfb_info.patch
cirrusfb-code-improvements.patch
cirrusfb-code-improvement-2nd-part.patch
pm3fb-header-file-cleanup.patch
pm2fb-hardware-cursor-support-for-the-permedia2.patch
pm2fb-panning-and-hardware-cursor-fixes.patch
tdfxfb-replace-busy-waiting-with-cpu_relax.patch
pm2fb-replace-busy-waiting-with-cpu_relax.patch
pm3fb-replace-busy-waiting-with-cpu_relax.patch
tdfxfb-checkpatch-fixes.patch
s3fb-do-not-allow-incorrect-pixclock-settings.patch
cyber2000fb-checkpatch-fixes.patch
