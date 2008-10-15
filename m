From: akpm@linux-foundation.org
Subject: - viafb-viafbmodes-viafbtxt-fix.patch removed from -mm tree
Date: Wed, 15 Oct 2008 16:52:05 -0700
Message-ID: <200810152352.m9FNq5vX023831@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753397AbYJOXwy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 19:52:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: JosephChan@via.com.tw, geert@linux-m68k.org, josephchan@via.com.tw, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     viafb-viafbmodes-viafbtxt fix
has been removed from the -mm tree.  Its filename was
     viafb-viafbmodes-viafbtxt-fix.patch

This patch was dropped because it was folded into viafb-viafbmodes-viafbtxt.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb-viafbmodes-viafbtxt fix
From: <JosephChan@via.com.tw>

Correct the description of VX800 2D acceleration, the driver diables the
acceleration function by defualt if you use VX800 chip.

Correct via_fb_ to viafb_ and remove the Kconfig part in viafb.txt.

Signed-off-by: Joseph Chan <josephchan@via.com.tw>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/viafb.txt |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN Documentation/fb/viafb.txt~viafb-viafbmodes-viafbtxt-fix Documentation/fb/viafb.txt
--- a/Documentation/fb/viafb.txt~viafb-viafbmodes-viafbtxt-fix
+++ a/Documentation/fb/viafb.txt
@@ -182,8 +182,9 @@ Notes:
        instead of calling common ioctl function FBIOPUT_VSCREENINFO since
        viafb doesn't support multi-head well, or it will cause screen crush.
     4. VX800 2D accelerator hasn't been supported in this driver yet. When
-       using driver on VX800, one should add parameter "viafb_accel=0" to
-       disable 2D accelerator.
+       using driver on VX800, the driver will disable the acceleration funciton.
+       as default.
+
 
 [Configure viafb with "fbset" tool]
 -----------------------------------
_

Patches currently in -mm which might be from JosephChan@via.com.tw are

viafb-viafbmodes-viafbtxt.patch
viafb-viafbmodes-viafbtxt-fix.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-makefile-kconfig.patch
viafb-accelc-accelh.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-accelc-accelh-update.patch
viafb-chiph-debugh.patch
viafb-dvic-dvih-globalc-and-globalh.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-ifacec-ifaceh-ioctlc-ioctlh.patch
viafb-lcdc-lcdh-lcdtblh.patch
viafb-makefile-shareh.patch
viafb-tbl1636c-tbl1636h-tbldpasettingc-tbldpasettingh.patch
viafb-viafbdevc-viafbdevh.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
viafb-viafbdevc-update.patch
viafb-via_i2cc-via_i2ch-viamodec-viamodeh.patch
viafb-via_utilityc-via_utilityh-vt1636c-vt1636h.patch
viafb-maintainers-entry.patch

