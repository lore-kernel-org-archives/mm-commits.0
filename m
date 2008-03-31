From: akpm@linux-foundation.org
Subject: - mtd-nand-add-out-label-in-rfc_from4.patch removed from -mm tree
Date: Mon, 31 Mar 2008 13:17:20 -0700
Message-ID: <200803312017.m2VKHKqZ023947@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57569 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753510AbYCaUSM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 16:18:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bigeasy@tglx.de, bigeasy@linutronix.de, dwmw2@infradead.org, joern@wohnheim.fh-wedel.de, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     mtd: nand: add out label in rfc_from4
has been removed from the -mm tree.  Its filename was
     mtd-nand-add-out-label-in-rfc_from4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
