From: akpm@linux-foundation.org
Subject: - platinumfb-the-pseudo_palette-is-only-16-elements.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:07:26 -0700
Message-ID: <200707172307.l6HN7Q7h012189@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32869 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762199AbXGQXPK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     platinumfb: the pseudo_palette is only 16 elements long
has been removed from the -mm tree.  Its filename was
     platinumfb-the-pseudo_palette-is-only-16-elements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: platinumfb: the pseudo_palette is only 16 elements long
From: "Antonino A. Daplas" <adaplas@gmail.com>

The pseudo_palette is only 16 elements long.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/platinumfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/platinumfb.c~platinumfb-the-pseudo_palette-is-only-16-elements drivers/video/platinumfb.c
--- a/drivers/video/platinumfb.c~platinumfb-the-pseudo_palette-is-only-16-elements
+++ a/drivers/video/platinumfb.c
@@ -52,7 +52,7 @@ struct fb_info_platinum {
 	struct {
 		__u8 red, green, blue;
 	}				palette[256];
-	u32				pseudo_palette[17];
+	u32				pseudo_palette[16];
 	
 	volatile struct cmap_regs	__iomem *cmap_regs;
 	unsigned long			cmap_regs_phys;
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
