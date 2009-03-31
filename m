From: akpm@linux-foundation.org
Subject: [folded] cirrusfb-fix-error-paths-in-cirrusfb_xxx_register-fix.patch removed from -mm tree
Date: Tue, 31 Mar 2009 15:08:52 -0700
Message-ID: <200903312208.n2VM8qLu017935@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763512AbZCaWKn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 18:10:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@poczta.fm, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     From: Krzysztof Helt <krzysztof.h1@poczta.fm>
has been removed from the -mm tree.  Its filename was
     cirrusfb-fix-error-paths-in-cirrusfb_xxx_register-fix.patch

This patch was dropped because it was folded into cirrusfb-fix-error-paths-in-cirrusfb_xxx_register.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: From: Krzysztof Helt <krzysztof.h1@poczta.fm>
From: Krzysztof Helt <krzysztof.h1@wp.pl>


My latest change introduced a typo
so fix it.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
---

Where can I get m68 cross compiler for PC able
to compile Amiga kernel?

Regards,
Krzysztof

index b96bc5d..070bf5f 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-fix-error-paths-in-cirrusfb_xxx_register-fix drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-fix-error-paths-in-cirrusfb_xxx_register-fix
+++ a/drivers/video/cirrusfb.c
@@ -2327,7 +2327,7 @@ static int __devinit cirrusfb_zorro_regi
 
 	ret = cirrusfb_register(info);
 	if (!ret)
-		return 0
+		return 0;
 
 	if (btype == BT_PICASSO4 || board_addr > 0x01000000)
 		iounmap(info->screen_base);
_

Patches currently in -mm which might be from krzysztof.h1@poczta.fm are

cirrusfb-convert-printks-to-dev_foo.patch
cirrusfb-various-improvements.patch
cirrusfb-fix-error-paths-in-cirrusfb_xxx_register.patch
cirrusfb-fix-error-paths-in-cirrusfb_xxx_register-fix.patch
cirrusfb-add-accelerator-constantpatch-compilation-fix.patch
fbmem-fix-fb_info-lock-and-mm-mmap_sem-circular-locking-dependency.patch
fbdev-uninline-lock_fb_info.patch
skeletonfb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
sm501fb-check-fb_alloc_cmap-return-value-and-handle-failure-properly.patch
sunxvr500-fix-cmap-memory-leaks.patch
tgafb-fix-cmap-memory-leak.patch
fbdev-newport-newport_wait-return-0-on-timeout.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-checkpatch-fixes.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-simplification.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-fix.patch
arkfb-fix-misplaced-parentheses.patch
uvesafb-bitwise-or-has-higher-precedence-than.patch
vesafb-bitwise-or-has-higher-precedence-than.patch
n411-add-missing-makefile-entry.patch
fb-add-s3c-fb-driver-for-newer-samsung-soc-framebuffer-devices.patch
uvesafb-fix-selecting-mode-with-the-vbemode-option.patch
omapfb-fix-argument-of-blank-operation.patch
radeonfb-suspend-resume-for-ati-mobility-radeon-rv350.patch
efifb-dmi-set-video-type.patch
intelfb-support-i854.patch

