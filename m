From: akpm@linux-foundation.org
Subject: + pnp-increase-the-number-of-memory-resources-from-12-to-24.patch added to -mm tree
Date: Mon, 17 Mar 2008 14:55:01 -0700
Message-ID: <200803172155.m2HLt2If000378@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753182AbYCQVzL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 17:55:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@youmustbejoking.demon.co.uk, ambx1@neo.rr.com, bjorn.helgaas@hp.com


The patch titled
     pnp: increase the number of memory resources from 12 to 24
has been added to the -mm tree.  Its filename is
     pnp-increase-the-number-of-memory-resources-from-12-to-24.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp: increase the number of memory resources from 12 to 24
From: Darren Salt <linux@youmustbejoking.demon.co.uk>

Increase the number of PnP memory resources from 12 to 24.

This removes an "exceeded the max num of mem resources" warning on boot.  I
also noticed the reservation of two more iomem ranges on the computer on which
this was tested.

Signed-off-by: Darren Salt <linux@youmustbejoking.demon.co.uk>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Adam Belay <ambx1@neo.rr.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pnp.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/pnp.h~pnp-increase-the-number-of-memory-resources-from-12-to-24 include/linux/pnp.h
--- a/include/linux/pnp.h~pnp-increase-the-number-of-memory-resources-from-12-to-24
+++ a/include/linux/pnp.h
@@ -14,7 +14,7 @@
 #include <linux/mod_devicetable.h>
 
 #define PNP_MAX_PORT		40
-#define PNP_MAX_MEM		12
+#define PNP_MAX_MEM		24
 #define PNP_MAX_IRQ		2
 #define PNP_MAX_DMA		2
 #define PNP_NAME_LEN		50
_

Patches currently in -mm which might be from linux@youmustbejoking.demon.co.uk are

pnp-increase-the-number-of-memory-resources-from-12-to-24.patch

