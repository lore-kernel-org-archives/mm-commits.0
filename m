From: akpm@linux-foundation.org
Subject: + mfd-drivers-mfd-wm8350-corec-doesnt-work-on-x86.patch added to -mm tree
Date: Wed, 15 Oct 2008 17:58:51 -0700
Message-ID: <200810160113.m9G1DOqj001103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751757AbYJPBN2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 21:13:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, sameo@openedhand.com


The patch titled
     mfd: drivers/mfd/wm8350-core.c doesn't work on x86
has been added to the -mm tree.  Its filename is
     mfd-drivers-mfd-wm8350-corec-doesnt-work-on-x86.patch

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
Subject: mfd: drivers/mfd/wm8350-core.c doesn't work on x86
From: Andrew Morton <akpm@linux-foundation.org>

drivers/mfd/wm8350-core.c: In function 'wm8350_device_init':
drivers/mfd/wm8350-core.c:1220: error: 'NO_IRQ' undeclared (first use in this function)
drivers/mfd/wm8350-core.c:1220: error: (Each undeclared identifier is reported only once
drivers/mfd/wm8350-core.c:1220: error: for each function it appears in.)

Cc: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/mfd/Kconfig~mfd-drivers-mfd-wm8350-corec-doesnt-work-on-x86 drivers/mfd/Kconfig
--- a/drivers/mfd/Kconfig~mfd-drivers-mfd-wm8350-corec-doesnt-work-on-x86
+++ a/drivers/mfd/Kconfig
@@ -116,6 +116,7 @@ config MFD_WM8350_CONFIG_MODE_3
 
 config MFD_WM8350_I2C
 	tristate "Support Wolfson Microelectronics WM8350 with I2C"
+	depends on !X86
 	select MFD_WM8350
 	depends on I2C
 	help
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
fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver.patch
ext2-avoid-printk-floods-in-the-face-of-directory-corruption.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
w1-be-able-to-manually-add-and-remove-slaves.patch
w1-new-driver-ds2431-chip.patch
gru-driver-minor-updates.patch
mfd-drivers-mfd-wm8350-corec-doesnt-work-on-x86.patch

