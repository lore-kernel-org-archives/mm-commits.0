From: akpm@linux-foundation.org
Subject: + mtd-nand-add-out-label-in-rfc_from4.patch added to -mm tree
Date: Mon, 24 Mar 2008 15:36:17 -0700
Message-ID: <200803242236.m2OMaHm4028866@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753607AbYCXWhG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 18:37:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bigeasy@tglx.de, bigeasy@linutronix.de, dwmw2@infradead.org, joern@wohnheim.fh-wedel.de, tglx@linutronix.de


The patch titled
     mtd: nand: add out label in rfc_from4
has been added to the -mm tree.  Its filename is
     mtd-nand-add-out-label-in-rfc_from4.patch

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
Subject: mtd: nand: add out label in rfc_from4
From: Sebastian Siewior <bigeasy@tglx.de>

This has been forgotten in commit f5bbdacc419 and nobody compiled the driver.

Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Joern Engel <joern@wh.fh-wedel.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/rtc_from4.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/nand/rtc_from4.c~mtd-nand-add-out-label-in-rfc_from4 drivers/mtd/nand/rtc_from4.c
--- a/drivers/mtd/nand/rtc_from4.c~mtd-nand-add-out-label-in-rfc_from4
+++ a/drivers/mtd/nand/rtc_from4.c
@@ -460,7 +460,7 @@ static int rtc_from4_errstat(struct mtd_
 			er_stat |= 1 << 1;
 		kfree(buf);
 	}
