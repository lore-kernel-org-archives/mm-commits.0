From: akpm@linux-foundation.org
Subject: - quirk-enable-msi-mapping-on-ht1000-v2.patch removed from -mm tree
Date: Thu, 13 Dec 2007 16:09:07 -0800
Message-ID: <200712140009.lBE0987U025924@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35244 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762574AbXLNAJy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Dec 2007 19:09:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sebastien.dugue@bull.net, acurrid@nvidia.com, ebiederm@xmission.com, mchan@broadcom.com, pchen@nvidia.com, prakash@punnoor.de, mm-commits@vger.kernel.org


The patch titled
     quirk: Enable MSI Mapping on HT1000 (update)
has been removed from the -mm tree.  Its filename was
     quirk-enable-msi-mapping-on-ht1000-v2.patch

This patch was dropped because it was folded into quirk-enable-msi-mapping-on-ht1000.patch

------------------------------------------------------
Subject: quirk: Enable MSI Mapping on HT1000 (update)
From: Sebastien Dugue <sebastien.dugue@bull.net>

  V2: removed the HT1000 bridge from the quirk_msi_ht_cap quirk as suggested
      by Michael Chan.

Signed-off-by: Sebastien Dugue <sebastien.dugue@bull.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michael Chan <mchan@broadcom.com>
Cc: Andy Currid <acurrid@nvidia.com>
Cc: Peer Chen <pchen@nvidia.com>
Cc: Prakash Punnoor <prakash@punnoor.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/pci/quirks.c~quirk-enable-msi-mapping-on-ht1000-v2 drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~quirk-enable-msi-mapping-on-ht1000-v2
+++ a/drivers/pci/quirks.c
@@ -1711,9 +1711,6 @@ static void __devinit quirk_msi_ht_cap(s
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS, PCI_DEVICE_ID_SERVERWORKS_HT2000_PCIE,
 			quirk_msi_ht_cap);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_SERVERWORKS,
-			PCI_DEVICE_ID_SERVERWORKS_HT1000_PXB,
-			quirk_msi_ht_cap);
 
 
 /*
_

Patches currently in -mm which might be from sebastien.dugue@bull.net are

quirk-enable-msi-mapping-on-ht1000.patch
quirk-enable-msi-mapping-on-ht1000-v2.patch
