From: akpm@linux-foundation.org
Subject: - hw_random-add-quality-categories-bcm43xx.patch removed from -mm tree
Date: Tue, 26 Jun 2007 11:45:52 -0700
Message-ID: <200706261845.l5QIjqpY032058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47986 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756075AbXFZSqg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 14:46:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mb@bu3sch.de, jeff@garzik.org, jordan.crouse@amd.com, mm-commits@vger.kernel.org


The patch titled
     hw_random: add quality categories
has been removed from the -mm tree.  Its filename was
     hw_random-add-quality-categories-bcm43xx.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: hw_random: add quality categories

--- bu3sch-wireless-dev.orig/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c	2007-06-23 11:50:59.000000000 +0200
+++ bu3sch-wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c	2007-06-24 15:26:14.000000000 +0200
@@ -2416,6 +2416,7 @@ static int bcm43xx_rng_init(struct bcm43
 	wl->rng.name = wl->rng_name;
 	wl->rng.data_read = bcm43xx_rng_read;
 	wl->rng.priv = (unsigned long)wl;
+	wl->rng.qual = HWRNG_QUAL_LOW;
 	wl->rng_initialized = 1;
 	err = hwrng_register(&wl->rng);
 	if (err) {

-- 
Greetings Michael.

Patches currently in -mm which might be from mb@bu3sch.de are

o_cloexec-for-scm_rights.patch
o_cloexec-for-scm_rights-fix.patch
o_cloexec-for-scm_rights-fix-2.patch
intel-rng-undo-mess-made-by-an-80-column-extremist.patch
hwrng-add-type-categories.patch
