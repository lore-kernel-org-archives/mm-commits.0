From: akpm@linux-foundation.org
Subject: + viafb-split-global-index-up-fix.patch added to -mm tree
Date: Wed, 03 Feb 2010 15:31:10 -0800
Message-ID: <201002032331.o13NVA1o026056@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756225Ab0BCXbu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 18:31:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn, krzysztof.h1@poczta.fm


The patch titled
     viafb-split-global-index-up-fix
has been added to the -mm tree.  Its filename is
     viafb-split-global-index-up-fix.patch

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
Subject: viafb-split-global-index-up-fix
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

v2: - fix variable name typo (missing 1) which would break SAMM

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/viafbdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/via/viafbdev.c~viafb-split-global-index-up-fix drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-split-global-index-up-fix
+++ a/drivers/video/via/viafbdev.c
@@ -166,7 +166,7 @@ static int viafb_set_par(struct fb_info 
 		DEBUG_MSG(KERN_INFO
 		"viafb_second_xres = %d, viafb_second_yres = %d, bpp = %d\n",
 			  viafb_second_xres, viafb_second_yres, viafb_bpp1);
-		vmode_entry = viafb_get_mode(viafb_second_xres,
+		vmode_entry1 = viafb_get_mode(viafb_second_xres,
 			viafb_second_yres);
 
 		viafb_update_device_setting(viafb_second_xres,
_

Patches currently in -mm which might be from FlorianSchandinat@gmx.de are

viafb-deprecate-private-ioctls.patch
viafb-remove-dead-code.patch
viafb-split-global-index-up.patch
viafb-split-global-index-up-fix.patch
viafb-remove-the-remaining-via_res_-uses.patch
viafb-some-dvi-cleanup.patch
viafb-yet-another-dead-code-removal.patch

