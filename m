From: akpm@linux-foundation.org
Subject: + arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch added to -mm tree
Date: Tue, 08 May 2007 11:18:31 -0700
Message-ID: <200705081818.l48IIV9r030291@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966035AbXEHSSg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 14:18:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: santiago@crfreenet.org, adaplas@gmail.com


The patch titled
     arkfb-new-framebuffer-driver-for-ark-logic-cards fix
has been added to the -mm tree.  Its filename is
     arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

s3fb-driver-fixes.patch
vga-vgastate-fix.patch
s3fb-updates.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
