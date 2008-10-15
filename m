From: akpm@linux-foundation.org
Subject: - viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 15 Oct 2008 16:53:05 -0700
Message-ID: <200810152353.m9FNr54E023952@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753459AbYJOXxc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 19:53:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, JosephChan@via.com.tw, geert@linux-m68k.org, josephchan@via.com.tw, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch

This patch was dropped because it was folded into viafb-dvic-dvih-globalc-and-globalh.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: suspect code indent for conditional statements
#121: FILE: drivers/video/via/dvi.c:100:
+	if (check_tmds_chip(VT1632_DEVICE_ID_REG, VT1632_DEVICE_ID) != FAIL) {

total: 0 errors, 1 warnings, 894 lines checked

./patches/viafb-dvic-dvih-globalc-and-globalh.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Joseph Chan <josephchan@via.com.tw>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/dvi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/video/via/dvi.c~viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes drivers/video/via/dvi.c
--- a/drivers/video/via/dvi.c~viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes
+++ a/drivers/video/via/dvi.c
@@ -98,7 +98,9 @@ int viafb_tmds_trasmitter_identify(void)
 		tmds_chip_info.tmds_chip_slave_addr = VT1632_TMDS_I2C_ADDR;
 	viaparinfo->chip_info->tmds_chip_info.i2c_port = I2CPORTINDEX;
 	if (check_tmds_chip(VT1632_DEVICE_ID_REG, VT1632_DEVICE_ID) != FAIL) {
-	/*Currently only support 12bits,dual edge,add 24bits mode later */
+		/*
+		 * Currently only support 12bits,dual edge,add 24bits mode later
+		 */
 		tmds_register_write(0x08, 0x3b);
 
 		DEBUG_MSG(KERN_INFO "\n VT1632 TMDS ! \n");
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
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver-cleanups.patch
ext2-avoid-printk-floods-in-the-face-of-directory-corruption-checkpatch-fixes.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
w1-be-able-to-manually-add-and-remove-slaves-fix.patch
w1-new-driver-ds2431-chip-fix.patch
gru-driver-minor-updates-fix.patch

