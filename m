From: akpm@linux-foundation.org
Subject: - meth-driver-renovation-fix.patch removed from -mm tree
Date: Tue, 29 May 2007 11:56:37 -0700
Message-ID: <200705291856.l4TIuaBY008656@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759481AbXE2S5L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 14:57:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     meth driver renovation (fix)
has been removed from the -mm tree.  Its filename was
     meth-driver-renovation-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: meth driver renovation (fix)
From: Ralf Baechle <ralf@linux-mips.org>

Fixed typo in meth_exit_module()

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/meth.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/meth.c~meth-driver-renovation-fix drivers/net/meth.c
--- a/drivers/net/meth.c~meth-driver-renovation-fix
+++ a/drivers/net/meth.c
@@ -851,7 +851,7 @@ static int __init meth_init_module(void)
 
 static void __exit meth_exit_module(void)
 {
-	platform_driver_register(&meth_driver);
+	platform_driver_unregister(&meth_driver);
 }
 
 module_init(meth_init_module);
_

Patches currently in -mm which might be from ralf@linux-mips.org are

lots-of-architectures-enable-arbitary-speed-tty-support.patch
git-mips.patch
serial-use-resource_size_t-for-port-io-addresses.patch
update-zilog-timeout.patch
