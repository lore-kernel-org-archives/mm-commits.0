From: akpm@linux-foundation.org
Subject: [merged]
 cris-arch-v32-cryptocop-print-a-hex-number-after-a-0x-prefix.patch removed
 from -mm tree
Date: Fri, 28 Oct 2016 11:31:02 -0700
Message-ID: <58139966.hm/DDCNwNYKUsMtU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45828 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031177AbcJ1SbD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2016 14:31:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, jesper.nilsson@axis.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cris/arch-v32: cryptocop: print a hex number after a 0x prefix
has been removed from the -mm tree.  Its filename was
     cris-arch-v32-cryptocop-print-a-hex-number-after-a-0x-prefix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Subject: cris/arch-v32: cryptocop: print a hex number after a 0x prefix

It makes the result hard to interpret correctly if a base 10 number is
prefixed by 0x. So change to a hex number.

Link: http://lkml.kernel.org/r/20161026125658.25728-6-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v32/drivers/cryptocop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/cris/arch-v32/drivers/cryptocop.c~cris-arch-v32-cryptocop-print-a-hex-number-after-a-0x-prefix arch/cris/arch-v32/drivers/cryptocop.c
--- a/arch/cris/arch-v32/drivers/cryptocop.c~cris-arch-v32-cryptocop-print-a-hex-number-after-a-0x-prefix
+++ a/arch/cris/arch-v32/drivers/cryptocop.c
@@ -3149,7 +3149,7 @@ static void print_dma_descriptors(struct
 	printk("print_dma_descriptors start\n");
 
 	printk("iop:\n");
-	printk("\tsid: 0x%lld\n", iop->sid);
+	printk("\tsid: 0x%llx\n", iop->sid);
 
 	printk("\tcdesc_out: 0x%p\n", iop->cdesc_out);
 	printk("\tcdesc_in: 0x%p\n", iop->cdesc_in);
_

Patches currently in -mm which might be from u.kleine-koenig@pengutronix.de are


