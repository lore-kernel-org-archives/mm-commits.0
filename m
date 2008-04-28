From: akpm@linux-foundation.org
Subject: - update-modedbtxt-documentation-about-mode_option-parameter-change.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:58:03 -0700
Message-ID: <200804282158.m3SLw36d018459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934933AbYD1V6G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:58:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     update modedb.txt documentation about mode_option parameter change
has been removed from the -mm tree.  Its filename was
     update-modedbtxt-documentation-about-mode_option-parameter-change.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: update modedb.txt documentation about mode_option parameter change
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Add names of drivers converted to "mode_option" parameter.

This is one step toward changing all fb drivers to have common "mode_option"
parameter.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/fb/modedb.txt |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN Documentation/fb/modedb.txt~update-modedbtxt-documentation-about-mode_option-parameter-change Documentation/fb/modedb.txt
--- a/Documentation/fb/modedb.txt~update-modedbtxt-documentation-about-mode_option-parameter-change
+++ a/Documentation/fb/modedb.txt
@@ -125,8 +125,12 @@ There may be more modes.
     amifb	- Amiga chipset frame buffer
     aty128fb	- ATI Rage128 / Pro frame buffer
     atyfb	- ATI Mach64 frame buffer
+    pm2fb	- Permedia 2/2V frame buffer
+    pm3fb	- Permedia 3 frame buffer
+    sstfb	- Voodoo 1/2 (SST1) chipset frame buffer
     tdfxfb	- 3D Fx frame buffer
     tridentfb	- Trident (Cyber)blade chipset frame buffer
+    vt8623fb	- VIA 8623 frame buffer
 
 BTW, only a few drivers use this at the moment. Others are to follow
 (feel free to send patches).
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch

