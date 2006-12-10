From: akpm@osdl.org
Subject: - ignore-generated-file-pca200e_ecdbin2.patch removed from -mm tree
Date: Sat, 09 Dec 2006 17:52:42 -0800
Message-ID: <200612100152.kBA1qg2Y010597@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40577 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759243AbWLJBxY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 9 Dec 2006 20:53:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, davem@davemloft.net, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     atm: ignore generated file pca200e_ecd.bin2
has been removed from the -mm tree.  Its filename was
     ignore-generated-file-pca200e_ecdbin2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atm: ignore generated file pca200e_ecd.bin2
From: Ralf Baechle <ralf@linux-mips.org>

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/atm/.gitignore |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/atm/.gitignore~ignore-generated-file-pca200e_ecdbin2 drivers/atm/.gitignore
--- a/drivers/atm/.gitignore~ignore-generated-file-pca200e_ecdbin2
+++ a/drivers/atm/.gitignore
@@ -2,4 +2,4 @@
 fore200e_mkfirm
 fore200e_pca_fw.c
 pca200e.bin
-
+pca200e_ecd.bin2
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

