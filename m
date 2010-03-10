From: akpm@linux-foundation.org
Subject: [folded] viafb-split-global-index-up-fix.patch removed from -mm tree
Date: Wed, 10 Mar 2010 14:50:14 -0800
Message-ID: <201003102250.o2AMoFvm008530@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757393Ab0CJWu0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Mar 2010 17:50:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: FlorianSchandinat@gmx.de, JosephChan@via.com.tw, ScottFang@viatech.com.cn, krzysztof.h1@poczta.fm, mm-commits@vger.kernel.org


The patch titled
     viafb-split-global-index-up-fix
has been removed from the -mm tree.  Its filename was
     viafb-split-global-index-up-fix.patch

This patch was dropped because it was folded into viafb-split-global-index-up.patch

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
viafb-reorder-initialization-for-dual-framebuffer-mode.patch
viafb-video-address-setting-revisited.patch
viafb-make-viafb_set_par-more-dual-framebuffer-compatible.patch
viafb-introduce-strict-parameter-checking.patch
viafb-split-color-mode-setting-up.patch
viafb-remove-dead-code-due-to-iga1_iga2.patch
viafb-make-some-variables-a-bit-less-global.patch
viafb-rework-color-checking.patch
viafb-some-virtual_xres-handling-fixes.patch
viafb-rework-color-setting.patch
viafb-support-color-depth-15-and-30.patch
drivers-video-via-fix-continuation-line-formats.patch

