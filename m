From: akpm@osdl.org
Subject: - agp-new-device-id-for-k8m890.patch removed from -mm tree
Date: Mon, 18 Dec 2006 21:46:58 -0800
Message-ID: <200612190546.kBJ5kwkk024335@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55311 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbWLSFrK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Dec 2006 00:47:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jon.nettleton@gmail.com, davej@codemonkey.org.uk, mm-commits@vger.kernel.org


The patch titled
     agp: new device id for k8m890
has been removed from the -mm tree.  Its filename was
     agp-new-device-id-for-k8m890.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: agp: new device id for k8m890
From: Jon Nettleton <jon.nettleton@gmail.com>

Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/agp/via-agp.c |    6 ++++++
 include/linux/pci_ids.h    |    1 +
 2 files changed, 7 insertions(+)

diff -puN drivers/char/agp/via-agp.c~agp-new-device-id-for-k8m890 drivers/char/agp/via-agp.c
--- a/drivers/char/agp/via-agp.c~agp-new-device-id-for-k8m890
+++ a/drivers/char/agp/via-agp.c
@@ -382,6 +382,11 @@ static struct agp_device_ids via_agp_dev
 		.device_id	= PCI_DEVICE_ID_VIA_P4M800CE,
 		.chipset_name	= "P4M800CE",
 	},
+	/* K8M890CE */
+	{
+		.device_id      = PCI_DEVICE_ID_VIA_K8M890CE,
+		.chipset_name   = "K8M890CE",
+       },
 
 	{ }, /* dummy final entry, always present */
 };
@@ -524,6 +529,7 @@ static const struct pci_device_id agp_vi
 	ID(PCI_DEVICE_ID_VIA_83_87XX_1),
 	ID(PCI_DEVICE_ID_VIA_3296_0),
 	ID(PCI_DEVICE_ID_VIA_P4M800CE),
+	ID(PCI_DEVICE_ID_VIA_K8M890CE),
 	{ }
 };
 
diff -puN include/linux/pci_ids.h~agp-new-device-id-for-k8m890 include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~agp-new-device-id-for-k8m890
+++ a/include/linux/pci_ids.h
@@ -1279,6 +1279,7 @@
 #define PCI_DEVICE_ID_VIA_3296_0	0x0296
 #define PCI_DEVICE_ID_VIA_8363_0	0x0305
 #define PCI_DEVICE_ID_VIA_P4M800CE	0x0314
+#define PCI_DEVICE_ID_VIA_K8M890CE	0x0336
 #define PCI_DEVICE_ID_VIA_8371_0	0x0391
 #define PCI_DEVICE_ID_VIA_8501_0	0x0501
 #define PCI_DEVICE_ID_VIA_82C561	0x0561
_

Patches currently in -mm which might be from jon.nettleton@gmail.com are

agp-new-device-id-for-k8m890.patch

