From: akpm@linux-foundation.org
Subject: - 68328fb-the-pseudo_palette-is-only-16-elements-long.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:07:10 -0700
Message-ID: <200707172307.l6HN7AVa012155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38897 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936300AbXGQXUI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:20:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     68328fb: the pseudo_palette is only 16 elements long
has been removed from the -mm tree.  Its filename was
     68328fb-the-pseudo_palette-is-only-16-elements-long.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: 68328fb: the pseudo_palette is only 16 elements long
From: "Antonino A. Daplas" <adaplas@gmail.com>

The pseudo_palette is only 16 elements long.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/68328fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/68328fb.c~68328fb-the-pseudo_palette-is-only-16-elements-long drivers/video/68328fb.c
--- a/drivers/video/68328fb.c~68328fb-the-pseudo_palette-is-only-16-elements-long
+++ a/drivers/video/68328fb.c
@@ -60,7 +60,7 @@ static u_long videomemory;
 static u_long videomemorysize;
 
 static struct fb_info fb_info;
-static u32 mc68x328fb_pseudo_palette[17];
+static u32 mc68x328fb_pseudo_palette[16];
 
 static struct fb_var_screeninfo mc68x328fb_default __initdata = {
 	.red =		{ 0, 8, 0 },
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
