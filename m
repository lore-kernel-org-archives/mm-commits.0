From: akpm@linux-foundation.org
Subject: + sb1250-macc-de-typedef-de-volatile-de-etc-update.patch added to -mm tree
Date: Fri, 14 Sep 2007 03:55:26 -0700
Message-ID: <200709141055.l8EAtQ7H001388@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34680 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751935AbXINKzm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 06:55:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, jeff@garzik.org


The patch titled
     sb1250-macc-de-typedef-de-volatile-de-etc update
has been added to the -mm tree.  Its filename is
     sb1250-macc-de-typedef-de-volatile-de-etc-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-mips.patch
sb1250-macc-de-typedef-de-volatile-de-etc.patch
sb1250-macc-de-typedef-de-volatile-de-etc-update.patch
include-linux-typesh-in-if_fddih.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
