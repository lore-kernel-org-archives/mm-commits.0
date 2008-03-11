From: akpm@linux-foundation.org
Subject: - tridentfb-fix-memory-size-detection.patch removed from -mm tree
Date: Mon, 10 Mar 2008 20:21:41 -0700
Message-ID: <200803110321.m2B3Lf6d019736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751956AbYCKDWM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 23:22:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     tridentfb: fix memory size detection
has been removed from the -mm tree.  Its filename was
     tridentfb-fix-memory-size-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tridentfb: fix memory size detection
From: Krzysztof Helt <krzysztof.h1@wp.pl>

Fix memory size multiplier during detection.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tridentfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/tridentfb.c~tridentfb-fix-memory-size-detection drivers/video/tridentfb.c
--- a/drivers/video/tridentfb.c~tridentfb-fix-memory-size-detection
+++ a/drivers/video/tridentfb.c
@@ -745,7 +745,7 @@ static unsigned int __devinit get_memsiz
 			switch (tmp) {
 
 			case 0x01:
-				k = 512;
+				k = 512 * Kb;
 				break;
 			case 0x02:
 				k = 6 * Mb;	/* XP */
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
pm2fb-correct-error-values-returned-from-probe-function.patch
pm2fb-change-option-mode-to-mode_option.patch
tridentfb-change-option-mode-to-mode_option.patch
pm3fb-change-option-mode-to-mode_option.patch
update-modedbtxt-documentation-about-mode_option-parameter-change.patch
vt8623fb-change-option-mode-to-mode_option.patch
arkfb-add-option-mode_option.patch
s3fb-add-option-mode_option.patch
fbdev-add-removed-option-mode-to-keep-compatibility.patch
video-replace-remaining-__function__-occurrences.patch

