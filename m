From: akpm@linux-foundation.org
Subject: - i4l-errors-with-assignments-in-if.patch removed from -mm tree
Date: Mon, 05 Nov 2007 21:51:53 -0800
Message-ID: <200711060551.lA65prTQ007126@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56862 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753476AbXKFFwd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 00:52:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     i4l: errors with assignments in if
has been removed from the -mm tree.  Its filename was
     i4l-errors-with-assignments-in-if.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i4l: errors with assignments in if
From: Roel Kluin <12o3l@tiscali.nl>

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Acked-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hisax/elsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/isdn/hisax/elsa.c~i4l-errors-with-assignments-in-if drivers/isdn/hisax/elsa.c
--- a/drivers/isdn/hisax/elsa.c~i4l-errors-with-assignments-in-if
+++ a/drivers/isdn/hisax/elsa.c
@@ -883,7 +883,7 @@ setup_elsa_isa(struct IsdnCard *card)
 	val += 'A' - 3;
 	if (val == 'B' || val == 'C')
 		val ^= 1;
-	if ((cs->subtyp == ELSA_PCFPRO) && (val = 'G'))
+	if ((cs->subtyp == ELSA_PCFPRO) && (val == 'G'))
 		val = 'C';
 	printk(KERN_INFO
 	       "Elsa: %s found at %#lx Rev.:%c IRQ %d\n",
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

origin.patch
unlock-when-ssp-tries-to-close-an-invalid-port.patch
git-dvb.patch
dvb-dont-return-with-locks-held.patch
lmc_ioctl-dont-return-with-locks-held-fix.patch
git-ocfs2.patch
cris-gpio-undo-locks-before-returning.patch
mips-undo-locking-on-error-path-returns.patch
mips-undo-locking-on-error-path-returns-checkpatch-fixes.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
