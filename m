From: akpm@osdl.org
Subject: - make-lm70_remove-a-__devexit-function.patch removed from -mm tree
Date: Mon, 18 Dec 2006 14:51:13 -0800
Message-ID: <200612182251.kBIMpDpm015025@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54157 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754735AbWLRWvW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Dec 2006 17:51:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Make lm70_remove a __devexit function
has been removed from the -mm tree.  Its filename was
     make-lm70_remove-a-__devexit-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make lm70_remove a __devexit function
From: Ralf Baechle <ralf@linux-mips.org>

Saves a few bytes on the module.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/hwmon/lm70.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/hwmon/lm70.c~make-lm70_remove-a-__devexit-function drivers/hwmon/lm70.c
--- a/drivers/hwmon/lm70.c~make-lm70_remove-a-__devexit-function
+++ a/drivers/hwmon/lm70.c
@@ -126,7 +126,7 @@ out_dev_reg_failed:
 	return status;
 }
 
-static int __exit lm70_remove(struct spi_device *spi)
+static int __devexit lm70_remove(struct spi_device *spi)
 {
 	struct lm70 *p_lm70 = dev_get_drvdata(&spi->dev);
 
_

Patches currently in -mm which might be from ralf@linux-mips.org are

fix-namespace-conflict-between-w9968cfc-on-mips.patch
mips-dbg_io-stray-brackets-fix.patch
git-mtd.patch
git-net.patch
fix-pnx8550-serial-breakage.patch
pnx8550-uart-driver.patch
pci-legacy-resource-fix.patch
pci-legacy-resource-fix-tidy.patch
xfs-remove-useless-wmb-memory-barrier.patch
ioc3-ioc4-pci-mem-space-resources.patch

