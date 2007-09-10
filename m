From: akpm@linux-foundation.org
Subject: + document-the-fact-that-smsc-ircc2-will-not-use-pnp-by-default.patch added to -mm tree
Date: Mon, 10 Sep 2007 01:39:20 -0700
Message-ID: <200709100839.l8A8dK85015707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57459 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755819AbXIJIja (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Sep 2007 04:39:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@dastyle.net, bjorn.helgaas@hp.com, samuel@sortiz.org


The patch titled
     Document the fact that smsc-ircc2 will not use PNP by default
has been added to the -mm tree.  Its filename is
     document-the-fact-that-smsc-ircc2-will-not-use-pnp-by-default.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Document the fact that smsc-ircc2 will not use PNP by default
From: Jonathan Bastien-Filiatrault <joe@dastyle.net>

This avoids user confusion when they see that their device is not detected.

Cc: Samuel Ortiz <samuel@sortiz.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/irda/smsc-ircc2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/irda/smsc-ircc2.c~document-the-fact-that-smsc-ircc2-will-not-use-pnp-by-default drivers/net/irda/smsc-ircc2.c
--- a/drivers/net/irda/smsc-ircc2.c~document-the-fact-that-smsc-ircc2-will-not-use-pnp-by-default
+++ a/drivers/net/irda/smsc-ircc2.c
@@ -81,7 +81,7 @@ MODULE_LICENSE("GPL");
 
 static int smsc_nopnp = 1;
 module_param_named(nopnp, smsc_nopnp, bool, 0);
-MODULE_PARM_DESC(nopnp, "Do not use PNP to detect controller settings");
+MODULE_PARM_DESC(nopnp, "Do not use PNP to detect controller settings, defaults to true");
 
 #define DMA_INVAL 255
 static int ircc_dma = DMA_INVAL;
_

Patches currently in -mm which might be from joe@dastyle.net are

document-the-fact-that-smsc-ircc2-will-not-use-pnp-by-default.patch
