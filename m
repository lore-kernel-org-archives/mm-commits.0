From: akpm@linux-foundation.org
Subject: + spi-spi_bfin5xx-remove-unused-label.patch added to -mm tree
Date: Tue, 08 Apr 2008 00:54:01 -0700
Message-ID: <200804080754.m387s1Cl015160@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751773AbYDHHyZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2008 03:54:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, cooloney@kernel.org, dbrownell@users.sourceforge.net


The patch titled
     spi: spi_bfin5xx: remove unused label
has been added to the -mm tree.  Its filename is
     spi-spi_bfin5xx-remove-unused-label.patch

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
Subject: spi: spi_bfin5xx: remove unused label
From: Michael Hennerich <michael.hennerich@analog.com>

Remove unused label, and associated compiler warning.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/spi/spi_bfin5xx.c~spi-spi_bfin5xx-remove-unused-label drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi-spi_bfin5xx-remove-unused-label
+++ a/drivers/spi/spi_bfin5xx.c
@@ -1319,7 +1319,6 @@ out_error_no_dma_ch:
 	iounmap((void *) drv_data->regs_base);
 out_error_ioremap:
 out_error_get_res:
-out_error:
 	spi_master_put(master);
 
 	return status;
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

spi-spi_bfin5xx-remove-unused-label.patch
input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch

