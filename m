From: akpm@linux-foundation.org
Subject: - offb-the-pseudo_palette-is-only-16-elements-long.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:07:24 -0700
Message-ID: <200707172307.l6HN7OdS012186@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37071 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935844AbXGQXPZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     offb: the pseudo_palette is only 16 elements long
has been removed from the -mm tree.  Its filename was
     offb-the-pseudo_palette-is-only-16-elements-long.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: offb: the pseudo_palette is only 16 elements long
From: "Antonino A. Daplas" <adaplas@gmail.com>

The pseudo_palette is only 16 elements long.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/offb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/offb.c~offb-the-pseudo_palette-is-only-16-elements-long drivers/video/offb.c
--- a/drivers/video/offb.c~offb-the-pseudo_palette-is-only-16-elements-long
+++ a/drivers/video/offb.c
@@ -271,7 +271,7 @@ static void __init offb_init_fb(const ch
 		return;
 	}
 
-	size = sizeof(struct fb_info) + sizeof(u32) * 17;
+	size = sizeof(struct fb_info) + sizeof(u32) * 16;
 
 	info = kmalloc(size, GFP_ATOMIC);
 	
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
