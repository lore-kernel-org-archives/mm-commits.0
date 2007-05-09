From: akpm@linux-foundation.org
Subject: - arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch removed from -mm tree
Date: Wed, 09 May 2007 02:07:20 -0700
Message-ID: <200705090907.l4997KG2018774@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754884AbXEIJHw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 05:07:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: santiago@crfreenet.org, adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     arkfb-new-framebuffer-driver-for-ark-logic-cards fix
has been removed from the -mm tree.  Its filename was
     arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch

This patch was dropped because it was folded into arkfb-new-framebuffer-driver-for-ark-logic-cards.patch

------------------------------------------------------
Subject: arkfb-new-framebuffer-driver-for-ark-logic-cards fix
From: Ondrej Zajicek <santiago@crfreenet.org>

Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/arkfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/arkfb.c~arkfb-new-framebuffer-driver-for-ark-logic-cards-fix drivers/video/arkfb.c
--- a/drivers/video/arkfb.c~arkfb-new-framebuffer-driver-for-ark-logic-cards-fix
+++ a/drivers/video/arkfb.c
@@ -122,7 +122,7 @@ MODULE_PARM_DESC(mtrr, "Enable write-com
 static int threshold = 4;
 
 module_param(threshold, int, 0644);
-MODULE_PARM_DESC(mtrr, "FIFO threshold");
+MODULE_PARM_DESC(threshold, "FIFO threshold");
 
 
 /* ------------------------------------------------------------------------- */
_

Patches currently in -mm which might be from santiago@crfreenet.org are

origin.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
