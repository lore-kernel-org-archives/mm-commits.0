From: akpm@linux-foundation.org
Subject: - fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver-cleanups.patch removed from -mm tree
Date: Wed, 15 Oct 2008 16:55:08 -0700
Message-ID: <200810152355.m9FNt86s024264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753809AbYJOX4b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 19:56:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, geert@linux-m68k.org, kristoffer.ericson@gmail.com, krzysztof.h1@poczta.fm, varenet@parisc-linux.org, mm-commits@vger.kernel.org


The patch titled
     fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver-cleanu=
ps
has been removed from the -mm tree.  Its filename was
     fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver-cleanu=
ps.patch

This patch was dropped because it was folded into fbdev-allow-more-chip=
-revisions-in-epson-s1d13-video-driver.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver-cl=
eanups
=46rom: Andrew Morton <akpm@linux-foundation.org>

- add trailing comma in table (so later alteratoins are cleaner)

- remove unneeded parentheses

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Thibaut Var=E8ne <varenet@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/s1d13xxxfb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/video/s1d13xxxfb.c~fbdev-allow-more-chip-revisions-in=
-epson-s1d13-video-driver-cleanups drivers/video/s1d13xxxfb.c
--- a/drivers/video/s1d13xxxfb.c~fbdev-allow-more-chip-revisions-in-eps=
on-s1d13-video-driver-cleanups
+++ a/drivers/video/s1d13xxxfb.c
@@ -51,8 +51,8 @@
 #endif
=20
 static const int __devinitconst s1d13xxxfb_revisions[] =3D {
-	S1D13506_CHIP_REV,/* Rev.4 on HP Jornada 7xx S1D13506 */
-	S1D13806_CHIP_REV /* Rev.7 on .. */
+	S1D13506_CHIP_REV,	/* Rev.4 on HP Jornada 7xx S1D13506 */
+	S1D13806_CHIP_REV,	/* Rev.7 on .. */
 };
=20
 /*
@@ -623,9 +623,9 @@ s1d13xxxfb_probe(struct platform_device=20
 	}
=20
 	if (!ret)
-		printk(KERN_INFO PFX "chip revision %i\n", (revision));
+		printk(KERN_INFO PFX "chip revision %i\n", revision);
 	else {
-		printk(KERN_INFO PFX "unknown chip revision %i\n", (revision));
+		printk(KERN_INFO PFX "unknown chip revision %i\n", revision);
 		goto bail;
 	}
=20
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

origin.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.pat=
ch
make-taint-bit-reliable-v3.patch
kernel-sysc-improve-code-generation.patch
compat-generic-compat-get-settimeofday.patch
allow-recursion-in-binfmt_script-and-binfmt_misc.patch
autofs4-track-uid-and-gid-of-last-mount-requester.patch
autofs4-add-miscellaneous-device-for-ioctls.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip.patch
viafb-accelc-accelh.patch
viafb-dvic-dvih-globalc-and-globalh.patch
viafb-hwc-hwh.patch
viafb-viafbdevc-viafbdevh.patch
fbdev-kconfig-update.patch
fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver.patch
fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver-cleanups.pa=
tch
ext2-avoid-printk-floods-in-the-face-of-directory-corruption-checkpatch=
-fixes.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
w1-be-able-to-manually-add-and-remove-slaves-fix.patch
w1-new-driver-ds2431-chip-fix.patch
gru-driver-minor-updates-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
