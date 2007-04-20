From: akpm@linux-foundation.org
Subject: + fix-spelling-in-drivers-video-kconfig.patch added to -mm tree
Date: Fri, 20 Apr 2007 16:05:35 -0700
Message-ID: <200704202305.l3KN5k55025973@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767320AbXDTXFt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 19:05:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: maxextreme@gmail.com, adaplas@gmail.com


The patch titled
     Fix spelling in drivers/video/Kconfig
has been added to the -mm tree.  Its filename is
     fix-spelling-in-drivers-video-kconfig.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix spelling in drivers/video/Kconfig
From: "Miguel Ojeda" <maxextreme@gmail.com>

Signed-off-by: Miguel Ojeda Sandonis <maxextreme@gmail.com>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

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

fix-spelling-in-drivers-video-kconfig.patch
add-webpages-url-and-summarize-3-lines.patch
