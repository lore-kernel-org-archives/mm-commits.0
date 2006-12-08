From: akpm@osdl.org
Subject: - video-select-set-for-vesa-fb.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:14:49 -0800
Message-ID: <200612082014.kB8KEnkc003218@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59884 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946898AbWLHUO6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:14:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsimmons@infradead.org, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     Video Select set for VESA FB
has been removed from the -mm tree.  Its filename was
     video-select-set-for-vesa-fb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Video Select set for VESA FB
From: James Simmons <jsimmons@infradead.org>

Automatically set VIDEO_SELECT when you select VESA FB.  Currently if you
select VESA FB with fbcon but don't select VGA console the box will not
have its video mode set.  Thus you get a blank screen.

Signed-off-by: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/video/Kconfig~video-select-set-for-vesa-fb drivers/video/Kconfig
--- a/drivers/video/Kconfig~video-select-set-for-vesa-fb
+++ a/drivers/video/Kconfig
@@ -552,6 +552,7 @@ config FB_VESA
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
+	select VIDEO_SELECT
 	help
 	  This is the frame buffer device driver for generic VESA 2.0
 	  compliant graphic cards. The older VESA 1.2 cards are not supported.
_

Patches currently in -mm which might be from jsimmons@infradead.org are

origin.patch
video-select-set-for-vesa-fb.patch
fbdev-update-after-backlight-argument-change.patch
proper-backlight-selection-for-fbdev-drivers.patch
fbdev-driver-for-ibm-gxt4500p-video-cards.patch

