From: akpm@linux-foundation.org
Subject: - pci_module_init-convertion-for-k8_edacc.patch removed from -mm tree
Date: Thu, 26 Apr 2007 14:05:51 -0700
Message-ID: <200704262105.l3QL5p17011504@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45497 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755092AbXDZVGB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Apr 2007 17:06:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: henne@nachtwindheim.de, mm-commits@vger.kernel.org


The patch titled
     pci_module_init() convertion for k8_edac.c
has been removed from the -mm tree.  Its filename was
     pci_module_init-convertion-for-k8_edacc.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: pci_module_init() convertion for k8_edac.c
From: Henrik Kretzschmar <henne@nachtwindheim.de>

pci_module_init() convertion for k8_edac.c

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/edac/k8_edac.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/k8_edac.c~pci_module_init-convertion-for-k8_edacc drivers/edac/k8_edac.c
--- a/drivers/edac/k8_edac.c~pci_module_init-convertion-for-k8_edacc
+++ a/drivers/edac/k8_edac.c
@@ -1865,7 +1865,7 @@ static struct pci_driver k8_driver = {
 
 static int __init k8_init(void)
 {
-	return pci_module_init(&k8_driver);
+	return pci_register_driver(&k8_driver);
 }
 
 static void __exit k8_exit(void)
_

Patches currently in -mm which might be from henne@nachtwindheim.de are

git-scsi-misc.patch
pci_module_init-convertion-in-tmscsimc.patch
pci_module_init-convertion-for-k8_edacc.patch
