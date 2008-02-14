From: akpm@linux-foundation.org
Subject: + update-modedbtxt-documentation-about-mode_option-parameter-change.patch added to -mm tree
Date: Thu, 14 Feb 2008 13:59:46 -0800
Message-ID: <200802142159.m1ELxkV1005080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47743 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754962AbYBNV7t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 16:59:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, adaplas@pol.net


The patch titled
     update modedb.txt documentation about mode_option parameter change
has been added to the -mm tree.  Its filename is
     update-modedbtxt-documentation-about-mode_option-parameter-change.patch

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

pm2fb-change-option-mode-to-mode_option.patch
tridentfb-change-option-mode-to-mode_option.patch
pm3fb-change-option-mode-to-mode_option.patch
update-modedbtxt-documentation-about-mode_option-parameter-change.patch
vt8623fb-change-option-mode-to-mode_option.patch
