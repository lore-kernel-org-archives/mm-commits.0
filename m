From: akpm@linux-foundation.org
Subject: +
 cris-arch-v32-cryptocop-print-a-hex-number-after-a-0x-prefix.patch added to -mm tree
Date: Wed, 26 Oct 2016 12:50:38 -0700
Message-ID: <5811090e.Yb4wHuTqEyW16hn4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37415 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933343AbcJZTuj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Oct 2016 15:50:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, jesper.nilsson@axis.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cris/arch-v32: cryptocop: print a hex number after a 0x prefix
has been added to the -mm tree.  Its filename is
     cris-arch-v32-cryptocop-print-a-hex-number-after-a-0x-prefix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cris-arch-v32-cryptocop-print-a-hex-number-after-a-0x-prefix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cris-arch-v32-cryptocop-print-a-hex-number-after-a-0x-prefix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

fs-exofs-print-a-hex-number-after-a-0x-prefix.patch
block-dac960-print-a-hex-number-after-a-0x-prefix.patch
ipack-print-a-hex-number-after-a-0x-prefix.patch
misc-sgi-gru-print-a-hex-number-after-a-0x-prefix.patch
cris-arch-v32-cryptocop-print-a-hex-number-after-a-0x-prefix.patch

