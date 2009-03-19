From: akpm@linux-foundation.org
Subject: + cirrusfb-add-accelerator-constantpatch-compilation-fix.patch added to -mm tree
Date: Thu, 19 Mar 2009 15:39:32 -0700
Message-ID: <200903192243.n2JMh88E013299@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759954AbZCSWpF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Mar 2009 18:45:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@poczta.fm, krzysztof.h1@wp.pl


The patch titled
     From: Krzysztof Helt <krzysztof.h1@poczta.fm>
has been added to the -mm tree.  Its filename is
     cirrusfb-add-accelerator-constantpatch-compilation-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: From: Krzysztof Helt <krzysztof.h1@poczta.fm>
From: Krzysztof Helt <krzysztof.h1@wp.pl>


Add a missing constant for the patch:
cirrusfb: add accelerator constant

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
---

I am sorry but the patch cirrusfb-add-accelerator-constant.patch
was not posted in full scope.

I spotted it after reviewing the patches accepted to the -mm tree.

Krzysztof

index 31527e1..fe7d0d7 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fb.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/fb.h~cirrusfb-add-accelerator-constantpatch-compilation-fix include/linux/fb.h
--- a/include/linux/fb.h~cirrusfb-add-accelerator-constantpatch-compilation-fix
+++ a/include/linux/fb.h
@@ -123,6 +123,7 @@ struct dentry;
 #define FB_ACCEL_TRIDENT_3DIMAGE 51	/* Trident 3DImage		*/
 #define FB_ACCEL_TRIDENT_BLADE3D 52	/* Trident Blade3D		*/
 #define FB_ACCEL_TRIDENT_BLADEXP 53	/* Trident BladeXP		*/
+#define FB_ACCEL_CIRRUS_ALPINE   53	/* Cirrus Logic 543x/544x/5480	*/
 #define FB_ACCEL_NEOMAGIC_NM2070 90	/* NeoMagic NM2070              */
 #define FB_ACCEL_NEOMAGIC_NM2090 91	/* NeoMagic NM2090              */
 #define FB_ACCEL_NEOMAGIC_NM2093 92	/* NeoMagic NM2093              */
_

Patches currently in -mm which might be from krzysztof.h1@poczta.fm are

cirrusfb-convert-printks-to-dev_foo.patch
cirrusfb-convert-printks-to-dev_foo-fix.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
cirrusfb-various-improvements.patch
cirrusfb-fix-error-paths-in-cirrusfb_xxx_register-fix.patch
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
cirrusfb-add-accelerator-constantpatch-compilation-fix.patch
fix-radeon-backlight-shutoff-flashes-momentarily.patch
intelfb-support-i854.patch

