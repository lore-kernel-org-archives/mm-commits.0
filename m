From: akpm@linux-foundation.org
Subject: [folded-merged]
 genalloc-rename-dev_get_gen_pool-to-gen_pool_get-fix.patch removed from -mm tree
Date: Tue, 30 Jun 2015 14:51:40 -0700
Message-ID: <55930f6c.mJ4bitizwSefso1e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53239 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbbF3Vvm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Jun 2015 17:51:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, atull@opensource.altera.com, broonie@kernel.org, dinguyen@opensource.altera.com, khilman@linaro.org, nicolas.ferre@atmel.com, sfr@canb.auug.org.au, vladimir_zapolskiy@mentor.com, mm-commits@vger.kernel.org


The patch titled
     Subject: genalloc-rename-dev_get_gen_pool-to-gen_pool_get-fix
has been removed from the -mm tree.  Its filename was
     genalloc-rename-dev_get_gen_pool-to-gen_pool_get-fix.patch

This patch was dropped because it was folded into genalloc-rename-dev_get_gen_pool-to-gen_pool_get.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: genalloc-rename-dev_get_gen_pool-to-gen_pool_get-fix

update arch/arm/mach-socfpga/pm.c

Cc: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Alan Tull <atull@opensource.altera.com>
Cc: Dinh Nguyen <dinguyen@opensource.altera.com>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-socfpga/pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm/mach-socfpga/pm.c~genalloc-rename-dev_get_gen_pool-to-gen_pool_get-fix arch/arm/mach-socfpga/pm.c
--- a/arch/arm/mach-socfpga/pm.c~genalloc-rename-dev_get_gen_pool-to-gen_pool_get-fix
+++ a/arch/arm/mach-socfpga/pm.c
@@ -56,7 +56,7 @@ static int socfpga_setup_ocram_self_refr
 		goto put_node;
 	}
 
-	ocram_pool = dev_get_gen_pool(&pdev->dev);
+	ocram_pool = get_gen_pool(&pdev->dev);
 	if (!ocram_pool) {
 		pr_warn("%s: ocram pool unavailable!\n", __func__);
 		ret = -ENODEV;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-meminit-inline-some-helper-functions.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx.patch
ipcshm-move-bug_on-check-into-shm_lock.patch
scsi-resolve-sg-buffer-const-ness-issue.patch
genalloc-rename-dev_get_gen_pool-to-gen_pool_get.patch

