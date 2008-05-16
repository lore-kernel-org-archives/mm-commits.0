From: akpm@linux-foundation.org
Subject: - mpc5200_psc_spi-typo-fix-in-header-block.patch removed from -mm tree
Date: Fri, 16 May 2008 15:52:25 -0700
Message-ID: <200805162252.m4GMqPHT003039@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753567AbYEPWwb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 May 2008 18:52:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: grant.likely@secretlab.ca, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     mpc5200_psc_spi: typo fix in header block
has been removed from the -mm tree.  Its filename was
     mpc5200_psc_spi-typo-fix-in-header-block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mpc5200_psc_spi: typo fix in header block
From: Grant Likely <grant.likely@secretlab.ca>

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Acked-by: David Brownell <david-b@pacbell.net>
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

origin.patch
fec_mpc52xx-mpc52xx_messages_default-2nd-netif_msg_ifdown-=-ifup.patch

