From: akpm@linux-foundation.org
Subject: + drivers-video-kconfig-fix-fb_pmagb_b-dependencies.patch added to -mm tree
Date: Mon, 17 Sep 2007 13:24:35 -0700
Message-ID: <200709172024.l8HKOaAu002988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35230 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755279AbXIQUY5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Sep 2007 16:24:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, adaplas@pol.net


The patch titled
     drivers/video/Kconfig: Fix FB_PMAGB_B dependencies
has been added to the -mm tree.  Its filename is
     drivers-video-kconfig-fix-fb_pmagb_b-dependencies.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/video/Kconfig: Fix FB_PMAGB_B dependencies
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Add a missing FB dependency to FB_PMAGB_B.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/Kconfig~drivers-video-kconfig-fix-fb_pmagb_b-dependencies drivers/video/Kconfig
--- a/drivers/video/Kconfig~drivers-video-kconfig-fix-fb_pmagb_b-dependencies
+++ a/drivers/video/Kconfig
@@ -1625,7 +1625,7 @@ config FB_PMAG_BA
 
 config FB_PMAGB_B
 	tristate "PMAGB-B TURBOchannel framebuffer support"
-	depends on TC
+	depends on FB && TC
  	select FB_CFB_FILLRECT
  	select FB_CFB_COPYAREA
  	select FB_CFB_IMAGEBLIT
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
git-mips.patch
sb1250-macc-de-typedef-de-volatile-de-etc.patch
net_sb1250_mac-update-kconfig-entry.patch
net_sb1250_mac-rename-to-sb1250_mac.patch
include-linux-typesh-in-if_fddih.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
drivers-video-kconfig-fix-fb_pmagb_b-dependencies.patch
