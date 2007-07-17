From: akpm@linux-foundation.org
Subject: - q40fb-the-pseudo_palette-is-only-16-elements-long.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:07:30 -0700
Message-ID: <200707172307.l6HN7U88012195@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53814 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761953AbXGQXPJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     q40fb: the pseudo_palette is only 16 elements long
has been removed from the -mm tree.  Its filename was
     q40fb-the-pseudo_palette-is-only-16-elements-long.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: q40fb: the pseudo_palette is only 16 elements long
From: "Antonino A. Daplas" <adaplas@gmail.com>

The pseudo_palette is only 16 elements long.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/q40fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/q40fb.c~q40fb-the-pseudo_palette-is-only-16-elements-long drivers/video/q40fb.c
--- a/drivers/video/q40fb.c~q40fb-the-pseudo_palette-is-only-16-elements-long
+++ a/drivers/video/q40fb.c
@@ -95,7 +95,7 @@ static int __init q40fb_probe(struct pla
 	/* mapped in q40/config.c */
 	q40fb_fix.smem_start = Q40_PHYS_SCREEN_ADDR;
 
-	info = framebuffer_alloc(sizeof(u32) * 256, &dev->dev);
+	info = framebuffer_alloc(sizeof(u32) * 16, &dev->dev);
 	if (!info)
 		return -ENOMEM;
 
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
