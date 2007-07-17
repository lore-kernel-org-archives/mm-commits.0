From: akpm@linux-foundation.org
Subject: - i810fb-the-pseudo_palette-is-only-16-elements-long.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:07:44 -0700
Message-ID: <200707172307.l6HN7iG4012216@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60081 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759549AbXGQXPH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     i810fb:  the pseudo_palette is only 16 elements long
has been removed from the -mm tree.  Its filename was
     i810fb-the-pseudo_palette-is-only-16-elements-long.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i810fb:  the pseudo_palette is only 16 elements long
From: "Antonino A. Daplas" <adaplas@gmail.com>

The pseudo_palette is only 16 elements long.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/i810/i810.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/i810/i810.h~i810fb-the-pseudo_palette-is-only-16-elements-long drivers/video/i810/i810.h
--- a/drivers/video/i810/i810.h~i810fb-the-pseudo_palette-is-only-16-elements-long
+++ a/drivers/video/i810/i810.h
@@ -266,7 +266,7 @@ struct i810fb_par {
 	struct i810fb_i2c_chan   chan[3];
 	struct mutex		 open_lock;
 	unsigned int		 use_count;
-	u32 pseudo_palette[17];
+	u32 pseudo_palette[16];
 	unsigned long mmio_start_phys;
 	u8 __iomem *mmio_start_virtual;
 	u8 *edid;
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
