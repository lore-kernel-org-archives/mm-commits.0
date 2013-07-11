From: akpm@linux-foundation.org
Subject: [merged] drivers-ide-delkin_cb-convert-to-module_pci_driver.patch removed from -mm tree
Date: Thu, 11 Jul 2013 13:16:39 -0700
Message-ID: <51df12a7.IaL7OrSYS+BqHFa1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab3GKUQj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Jul 2013 16:16:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, libo.chen@huawei.com, davem@davemloft.net, clbchenlibo.chen@huawei.com

Subject: [merged] drivers-ide-delkin_cb-convert-to-module_pci_driver.patch removed from -mm tree
To: clbchenlibo.chen@huawei.com,davem@davemloft.net,libo.chen@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 11 Jul 2013 13:16:39 -0700


The patch titled
     Subject: drivers/ide/delkin_cb.c: convert to module_pci_driver
has been removed from the -mm tree.  Its filename was
     drivers-ide-delkin_cb-convert-to-module_pci_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Libo Chen <clbchenlibo.chen@huawei.com>
Subject: drivers/ide/delkin_cb.c: convert to module_pci_driver

Signed-off-by: Libo Chen <libo.chen@huawei.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/delkin_cb.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/ide/delkin_cb.c~drivers-ide-delkin_cb-convert-to-module_pci_driver drivers/ide/delkin_cb.c
--- a/drivers/ide/delkin_cb.c~drivers-ide-delkin_cb-convert-to-module_pci_driver
+++ a/drivers/ide/delkin_cb.c
@@ -173,18 +173,7 @@ static struct pci_driver delkin_cb_pci_d
 	.resume		= delkin_cb_resume,
 };
 
-static int __init delkin_cb_init(void)
-{
-	return pci_register_driver(&delkin_cb_pci_driver);
-}
-
-static void __exit delkin_cb_exit(void)
-{
-	pci_unregister_driver(&delkin_cb_pci_driver);
-}
