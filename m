From: akpm@linux-foundation.org
Subject: [merged] drivers-pci-hotplug-ibmphp_corec-fix-warning-due-to-missing-module_exit.patch removed from -mm tree
Date: Wed, 06 May 2009 13:47:41 -0700
Message-ID: <200905062047.n46KlfSJ011219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760282AbZEFUuT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 May 2009 16:50:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: helight.xu@gmail.com, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     drivers/pci/hotplug/ibmphp_core.c: fix warning due to missing module_exit()
has been removed from the -mm tree.  Its filename was
     drivers-pci-hotplug-ibmphp_corec-fix-warning-due-to-missing-module_exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/pci/hotplug/ibmphp_core.c: fix warning due to missing module_exit()
From: Zhenwen Xu <helight.xu@gmail.com>

drivers/pci/hotplug/ibmphp_core.c:1414: warning: `ibmphp_exit' defined but not used

Signed-off-by: Zhenwen Xu <helight.xu@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/ibmphp_core.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/pci/hotplug/ibmphp_core.c~drivers-pci-hotplug-ibmphp_corec-fix-warning-due-to-missing-module_exit drivers/pci/hotplug/ibmphp_core.c
--- a/drivers/pci/hotplug/ibmphp_core.c~drivers-pci-hotplug-ibmphp_corec-fix-warning-due-to-missing-module_exit
+++ a/drivers/pci/hotplug/ibmphp_core.c
@@ -1419,3 +1419,4 @@ static void __exit ibmphp_exit(void)
 }
 
 module_init(ibmphp_init);
+module_exit(ibmphp_exit);
_

Patches currently in -mm which might be from helight.xu@gmail.com are

linux-next.patch
drivers-leds-leds-gpioc-fix-a-section-mismatch.patch
drivers-scsi-ncr_d700c-fix-irq-handler-return-type.patch

