From: akpm@linux-foundation.org
Subject: - hwrng-add-type-categories-bcm43xx.patch removed from -mm tree
Date: Wed, 25 Jul 2007 13:04:06 -0700
Message-ID: <200707252004.l6PK46Za019472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48887 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750982AbXGYUFK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jul 2007 16:05:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mb@bu3sch.de, hmh@hmh.eng.br, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     hwrng: add type categories
has been removed from the -mm tree.  Its filename was
     hwrng-add-type-categories-bcm43xx.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: hwrng: add type categories

Index: bu3sch-wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c
===================================================================
--- bu3sch-wireless-dev.orig/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c	2007-06-26 19:59:19.000000000 +0200
+++ bu3sch-wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c	2007-06-26 20:11:52.000000000 +0200
@@ -2399,6 +2399,7 @@ static int bcm43xx_rng_init(struct bcm43
 	wl->rng.name = wl->rng_name;
 	wl->rng.data_read = bcm43xx_rng_read;
 	wl->rng.priv = (unsigned long)wl;
+	wl->rng.type = HWRNG_TYPE_BAD;
 	wl->rng_initialized = 1;
 	err = hwrng_register(&wl->rng);
 	if (err) {


Patches currently in -mm which might be from mb@bu3sch.de are

merge-the-sonics-silicon-backplane-subsystem.patch
merge-the-sonics-silicon-backplane-subsystem-fix.patch
ssb-add-a-driver-for-the-broadcom-ohci-core.patch
pure_initcall-id-inconsistency.patch
