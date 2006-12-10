From: akpm@osdl.org
Subject: - mmc-fix-syntax-error.patch removed from -mm tree
Date: Sat, 09 Dec 2006 17:52:29 -0800
Message-ID: <200612100152.kBA1qTWl010576@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40504 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759166AbWLJBwp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 9 Dec 2006 20:52:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, david-b@pacbell.net, drzeus@drzeus.cx, mm-commits@vger.kernel.org


The patch titled
     mmc: fix syntax error
has been removed from the -mm tree.  Its filename was
     mmc-fix-syntax-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mmc: fix syntax error
From: Ralf Baechle <ralf@linux-mips.org>

Fix syntax error introduced in ab7aefd0b38297e6d2d71f43e8f81f9f4a36cdae.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/mmc/au1xmmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/au1xmmc.c~mmc-fix-syntax-error drivers/mmc/au1xmmc.c
--- a/drivers/mmc/au1xmmc.c~mmc-fix-syntax-error
+++ a/drivers/mmc/au1xmmc.c
@@ -875,7 +875,7 @@ static void au1xmmc_init_dma(struct au1x
 	host->rx_chan = rxchan;
 }
 
-struct const mmc_host_ops au1xmmc_ops = {
+static const struct mmc_host_ops au1xmmc_ops = {
 	.request	= au1xmmc_request,
 	.set_ios	= au1xmmc_set_ios,
 };
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
mips-dbg_io-stray-brackets-fix.patch
git-mtd.patch
git-net.patch
fix-pnx8550-serial-breakage.patch
pnx8550-uart-driver.patch
pci-legacy-resource-fix.patch
pci-legacy-resource-fix-tidy.patch
sysctl-remove-unused-context-param.patch
dont-build-some-broken-isdn-drivers-on-big-endian-mips.patch

