From: akpm@linux-foundation.org
Subject: + mpc5200_psc_spi-typo-fix-in-header-block.patch added to -mm tree
Date: Mon, 12 May 2008 15:13:25 -0700
Message-ID: <200805122213.m4CMDPLl011755@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751805AbYELWNe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 May 2008 18:13:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: grant.likely@secretlab.ca, david-b@pacbell.net


The patch titled
     mpc5200_psc_spi: typo fix in header block
has been added to the -mm tree.  Its filename is
     mpc5200_psc_spi-typo-fix-in-header-block.patch

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
Subject: mpc5200_psc_spi: typo fix in header block
From: Grant Likely <grant.likely@secretlab.ca>

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/mpc52xx_psc_spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/mpc52xx_psc_spi.c~mpc5200_psc_spi-typo-fix-in-header-block drivers/spi/mpc52xx_psc_spi.c
--- a/drivers/spi/mpc52xx_psc_spi.c~mpc5200_psc_spi-typo-fix-in-header-block
+++ a/drivers/spi/mpc52xx_psc_spi.c
@@ -1,5 +1,5 @@
 /*
- * MPC52xx SPC in SPI mode driver.
+ * MPC52xx PSC in SPI mode driver.
  *
  * Maintainer: Dragos Carp
  *
_

Patches currently in -mm which might be from grant.likely@secretlab.ca are

mpc5200_psc_spi-typo-fix-in-header-block.patch

