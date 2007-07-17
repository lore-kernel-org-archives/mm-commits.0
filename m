From: akpm@linux-foundation.org
Subject: - atyfb-the-pseudo_palette-is-only-16-elements-long.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:07:40 -0700
Message-ID: <200707172307.l6HN7eW7012210@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59888 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759454AbXGQXPG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     atyfb: the pseudo_palette is only 16 elements long
has been removed from the -mm tree.  Its filename was
     atyfb-the-pseudo_palette-is-only-16-elements-long.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atyfb: the pseudo_palette is only 16 elements long
From: "Antonino A. Daplas" <adaplas@gmail.com>

The pseudo_palette is only 16 elements long.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/atyfb_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/aty/atyfb_base.c~atyfb-the-pseudo_palette-is-only-16-elements-long drivers/video/aty/atyfb_base.c
--- a/drivers/video/aty/atyfb_base.c~atyfb-the-pseudo_palette-is-only-16-elements-long
+++ a/drivers/video/aty/atyfb_base.c
@@ -541,7 +541,7 @@ static char ram_off[] __devinitdata = "O
 #endif /* CONFIG_FB_ATY_CT */
 
 
-static u32 pseudo_palette[17];
+static u32 pseudo_palette[16];
 
 #ifdef CONFIG_FB_ATY_GX
 static char *aty_gx_ram[8] __devinitdata = {
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
