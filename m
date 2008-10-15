From: akpm@linux-foundation.org
Subject: - viafb-viafbmodes-viafbtxt-fix-fix.patch removed from -mm tree
Date: Wed, 15 Oct 2008 16:52:08 -0700
Message-ID: <200810152352.m9FNq86f023836@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753658AbYJOXwy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 19:52:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, JosephChan@via.com.tw, geert@linux-m68k.org, josephchan@via.com.tw, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     viafb-viafbmodes-viafbtxt-fix-fix
has been removed from the -mm tree.  Its filename was
     viafb-viafbmodes-viafbtxt-fix-fix.patch

This patch was dropped because it was folded into viafb-viafbmodes-viafbtxt.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb-viafbmodes-viafbtxt-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: <JosephChan@via.com.tw>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Joseph Chan <josephchan@via.com.tw>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/viafb.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/fb/viafb.txt~viafb-viafbmodes-viafbtxt-fix-fix Documentation/fb/viafb.txt
--- a/Documentation/fb/viafb.txt~viafb-viafbmodes-viafbtxt-fix-fix
+++ a/Documentation/fb/viafb.txt
@@ -182,8 +182,8 @@ Notes:
        instead of calling common ioctl function FBIOPUT_VSCREENINFO since
        viafb doesn't support multi-head well, or it will cause screen crush.
     4. VX800 2D accelerator hasn't been supported in this driver yet. When
-       using driver on VX800, the driver will disable the acceleration funciton.
-       as default.
+       using driver on VX800, the driver will disable the acceleration
+       function as default.
 
 
 [Configure viafb with "fbset" tool]
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
viafb-viafbmodes-viafbtxt.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-accelc-accelh-checkpatch-fixes.patch
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

