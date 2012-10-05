From: akpm@linux-foundation.org
Subject: [merged] sections-fix-section-conflicts-in-drivers-mmc.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:13:02 -0700
Message-ID: <20121005201303.19AAF5C0066@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:60205 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab2JEUNG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:13:06 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so98801lah.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:13:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, cjb@laptop.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sections: fix section conflicts in drivers/mmc
has been removed from the -mm tree.  Its filename was
     sections-fix-section-conflicts-in-drivers-mmc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: sections: fix section conflicts in drivers/mmc

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Chris Ball <cjb@laptop.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/sdhci-pci.c~sections-fix-section-conflicts-in-drivers-mmc drivers/mmc/host/sdhci-pci.c
--- a/drivers/mmc/host/sdhci-pci.c~sections-fix-section-conflicts-in-drivers-mmc
+++ a/drivers/mmc/host/sdhci-pci.c
@@ -653,7 +653,7 @@ static const struct sdhci_pci_fixes sdhc
 	.probe		= via_probe,
 };
 
-static const struct pci_device_id pci_ids[] __devinitdata = {
+static const struct pci_device_id pci_ids[] __devinitconst = {
 	{
 		.vendor		= PCI_VENDOR_ID_RICOH,
 		.device		= PCI_DEVICE_ID_RICOH_R5C822,
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch

