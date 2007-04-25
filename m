From: akpm@linux-foundation.org
Subject: - fix-spelling-in-drivers-video-kconfig.patch removed from -mm tree
Date: Wed, 25 Apr 2007 13:38:45 -0700
Message-ID: <200704252038.l3PKcjZS012249@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993117AbXDYUjH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 16:39:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maxextreme@gmail.com, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Fix spelling in drivers/video/Kconfig
has been removed from the -mm tree.  Its filename was
     fix-spelling-in-drivers-video-kconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix spelling in drivers/video/Kconfig
From: "Miguel Ojeda" <maxextreme@gmail.com>

Signed-off-by: Miguel Ojeda Sandonis <maxextreme@gmail.com>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/Kconfig~fix-spelling-in-drivers-video-kconfig drivers/video/Kconfig
--- a/drivers/video/Kconfig~fix-spelling-in-drivers-video-kconfig
+++ a/drivers/video/Kconfig
@@ -139,7 +139,7 @@ config FB_TILEBLITTING
 	 This is particularly important to one driver, matroxfb.  If
 	 unsure, say N.
 
-comment "Frambuffer hardware drivers"
+comment "Frame buffer hardware drivers"
 	depends on FB
 
 config FB_CIRRUS
_

Patches currently in -mm which might be from maxextreme@gmail.com are

origin.patch
add-webpages-url-and-summarize-3-lines.patch
