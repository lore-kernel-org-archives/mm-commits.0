From: akpm@linux-foundation.org
Subject: - sfc-remove-unncesssary-ul-suffixes-on-0-literals.patch removed from -mm tree
Date: Fri, 23 May 2008 11:59:09 -0700
Message-ID: <200805231859.m4NIx9fZ004209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48066 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753449AbYEWS7P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 May 2008 14:59:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhutchings@solarflare.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     sfc: remove unncesssary UL suffixes on 0 literals
has been removed from the -mm tree.  Its filename was
     sfc-remove-unncesssary-ul-suffixes-on-0-literals.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sfc: remove unncesssary UL suffixes on 0 literals
From: Ben Hutchings <bhutchings@solarflare.com>

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sfc/efx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/sfc/efx.c~sfc-remove-unncesssary-ul-suffixes-on-0-literals drivers/net/sfc/efx.c
--- a/drivers/net/sfc/efx.c~sfc-remove-unncesssary-ul-suffixes-on-0-literals
+++ a/drivers/net/sfc/efx.c
@@ -793,7 +793,7 @@ static int efx_init_io(struct efx_nic *e
  fail4:
 	release_mem_region(efx->membase_phys, efx->type->mem_map_size);
  fail3:
-	efx->membase_phys = 0UL;
+	efx->membase_phys = 0;
  fail2:
 	pci_disable_device(efx->pci_dev);
  fail1:
@@ -811,7 +811,7 @@ static void efx_fini_io(struct efx_nic *
 
 	if (efx->membase_phys) {
 		pci_release_region(efx->pci_dev, efx->type->mem_bar);
-		efx->membase_phys = 0UL;
+		efx->membase_phys = 0;
 	}
 
 	pci_disable_device(efx->pci_dev);
_

Patches currently in -mm which might be from bhutchings@solarflare.com are

git-net.patch

