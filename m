From: akpm@linux-foundation.org
Subject: - fbdev-kconfig-update-fix.patch removed from -mm tree
Date: Wed, 15 Oct 2008 16:53:59 -0700
Message-ID: <200810152353.m9FNrx27024041@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753685AbYJOXzO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 19:55:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, geert@linux-m68k.org, krzysztof.h1@wp.pl, mm-commits@vger.kernel.org


The patch titled
     fbdev-kconfig-update-fix
has been removed from the -mm tree.  Its filename was
     fbdev-kconfig-update-fix.patch

This patch was dropped because it was folded into fbdev-kconfig-update.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev-kconfig-update-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix text

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/Kconfig~fbdev-kconfig-update-fix drivers/video/Kconfig
--- a/drivers/video/Kconfig~fbdev-kconfig-update-fix
+++ a/drivers/video/Kconfig
@@ -256,7 +256,7 @@ config FB_PM2
 	help
 	  This is the frame buffer device driver for cards based on
 	  the 3D Labs Permedia, Permedia 2 and Permedia 2V chips.
-	  The driver was tested on following cards are:
+	  The driver was tested on the following cards:
 		Diamond FireGL 1000 PRO AGP
 		ELSA Gloria Synergy PCI
 		Appian Jeronimo PRO (both heads) PCI
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch
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
fbdev-kconfig-update-fix.patch
fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver-cleanups.patch
ext2-avoid-printk-floods-in-the-face-of-directory-corruption-checkpatch-fixes.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
w1-be-able-to-manually-add-and-remove-slaves-fix.patch
w1-new-driver-ds2431-chip-fix.patch
gru-driver-minor-updates-fix.patch

