From: akpm@linux-foundation.org
Subject: - cyclades-use-ioremap_nocache-for-clarity-as-proposed.patch removed from -mm tree
Date: Thu, 01 May 2008 02:29:56 -0700
Message-ID: <200805010929.m419Tu0t030721@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757419AbYEAJaW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:30:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     cyclades: use ioremap_nocache for clarity as proposed
has been removed from the -mm tree.  Its filename was
     cyclades-use-ioremap_nocache-for-clarity-as-proposed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cyclades: use ioremap_nocache for clarity as proposed
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Acked-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/cyclades.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/cyclades.c~cyclades-use-ioremap_nocache-for-clarity-as-proposed drivers/char/cyclades.c
--- a/drivers/char/cyclades.c~cyclades-use-ioremap_nocache-for-clarity-as-proposed
+++ a/drivers/char/cyclades.c
@@ -4556,7 +4556,7 @@ static int __init cy_detect_isa(void)
 			return nboard;
 
 		/* probe for CD1400... */
-		cy_isa_address = ioremap(isa_address, CyISA_Ywin);
+		cy_isa_address = ioremap_nocache(isa_address, CyISA_Ywin);
 		if (cy_isa_address == NULL) {
 			printk(KERN_ERR "Cyclom-Y/ISA: can't remap base "
 					"address\n");
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_atiixp-simplex-clear.patch
pata_atiixp-dont-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
generic-irq-let-setup_irq-reenable-a-shared-irq.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
sxc-fix-printk-warnings-on-sparc32.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

