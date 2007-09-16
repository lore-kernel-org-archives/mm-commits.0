From: akpm@linux-foundation.org
Subject: - sb1250-macc-de-typedef-de-volatile-de-etc-update.patch removed from -mm tree
Date: Sun, 16 Sep 2007 01:27:44 -0700
Message-ID: <200709160827.l8G8RiLH007335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60559 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751535AbXIPI2F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 04:28:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     sb1250-macc-de-typedef-de-volatile-de-etc update
has been removed from the -mm tree.  Its filename was
     sb1250-macc-de-typedef-de-volatile-de-etc-update.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: sb1250-macc-de-typedef-de-volatile-de-etc update
From: "Maciej W. Rozycki" <macro@linux-mips.org>

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sb1250-mac.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/net/sb1250-mac.c~sb1250-macc-de-typedef-de-volatile-de-etc-update drivers/net/sb1250-mac.c
--- a/drivers/net/sb1250-mac.c~sb1250-macc-de-typedef-de-volatile-de-etc-update
+++ a/drivers/net/sb1250-mac.c
@@ -242,7 +242,6 @@ struct sbmac_softc {
 	/*
 	 * Linux-specific things
 	 */
-
 	struct net_device	*sbm_dev;	/* pointer to linux device */
 	spinlock_t sbm_lock;			/* spin lock */
 	struct timer_list	sbm_timer;	/* for monitoring MII */
@@ -782,7 +781,7 @@ static void sbdma_initctx(struct sbmacdm
 	 */
 
 	d->sbdma_ctxtable = kcalloc(d->sbdma_maxdescr,
-				sizeof(*d->sbdma_ctxtable), GFP_KERNEL);
+				    sizeof(*d->sbdma_ctxtable), GFP_KERNEL);
 
 #ifdef CONFIG_SBMAC_COALESCE
 	/*
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
git-mips.patch
sb1250-macc-de-typedef-de-volatile-de-etc.patch
sb1250-macc-de-typedef-de-volatile-de-etc-update.patch
net_sb1250_mac-update-kconfig-entry.patch
net_sb1250_mac-rename-to-sb1250_mac.patch
include-linux-typesh-in-if_fddih.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
