From: akpm@linux-foundation.org
Subject: + cirrusfb-remove-information-about-memory-size-during-mode-change.patch added to -mm tree
Date: Thu, 28 Aug 2008 17:48:11 -0700
Message-ID: <200808290048.m7T0mBlb023103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753612AbYH2Aso (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Aug 2008 20:48:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl


The patch titled
     cirrusfb: remove information about memory size during mode change
has been added to the -mm tree.  Its filename is
     cirrusfb-remove-information-about-memory-size-during-mode-change.patch

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
Subject: cirrusfb: remove information about memory size during mode change
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Remove information about memory size displayed twice each time a display
mode change.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cirrusfb.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/video/cirrusfb.c~cirrusfb-remove-information-about-memory-size-during-mode-change drivers/video/cirrusfb.c
--- a/drivers/video/cirrusfb.c~cirrusfb-remove-information-about-memory-size-during-mode-change
+++ a/drivers/video/cirrusfb.c
@@ -1949,8 +1949,6 @@ static void init_vgachip(struct fb_info 
 	/* misc... */
 	WHDR(cinfo, 0);	/* Hidden DAC register: - */
 
-	printk(KERN_DEBUG "cirrusfb: This board has %ld bytes of DRAM memory\n",
-		info->screen_size);
 	DPRINTK("EXIT\n");
 	return;
 }
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

cirrusfb-check_par-fixes.patch
tdfxfb-fix-sdram-memory-size-detection.patch
tdfxfb-fix-frame-buffer-name-overrun.patch
linux-next.patch
fb-metronome-printk-format-warning.patch
rtc-m48t59-reduce-structure-m48t59_private.patch
rtc-m48t59-add-support-for-m48t02-and-m48t59-chips-2nd-rev.patch
fb-convert-lock-unlock_kernel-into-local-fb-mutex.patch
neofb-reduce-panning-function.patch
viafb-accelc-accelh-update.patch
viafb-viafbdevc-update.patch
fbdev-kconfig-update.patch
fbdev-kconfig-update-fix.patch
neofb-kill-some-redundant-code.patch
vga16fb-remove-open_lock-mutex.patch
neofb-remove-open_lock-mutex.patch
cirrusfb-remove-information-about-memory-size-during-mode-change.patch
cirrusfb-simplify-clock-calculation.patch
cirrusfb-remove-24-bpp-mode.patch
cirrusfb-drop-device-pointers-from-cirrusfb_info.patch
tdfxfb-do-not-make-changes-to-default-tdfx_fix.patch

