From: akpm@linux-foundation.org
Subject: - include-linux-pci_id-h-add-amd-northbridge-defines.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:06:51 -0700
Message-ID: <200707192006.l6JK6pfP020199@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38418 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759972AbXGSUPT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     include/linux/pci_id.h: add amd northbridge defines
has been removed from the -mm tree.  Its filename was
     include-linux-pci_id-h-add-amd-northbridge-defines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: include/linux/pci_id.h: add amd northbridge defines
From: Douglas Thompson <dougthompson@xmission.com>

pci_ids.h needs two of the AMD NB device-ids namely, Addressmap and the Memory
Controller devices

This patch adds those to the pci_id.h include file

Signed-off-by:	Douglas Thompson <dougthompson@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pci_ids.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/pci_ids.h~include-linux-pci_id-h-add-amd-northbridge-defines include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~include-linux-pci_id-h-add-amd-northbridge-defines
+++ a/include/linux/pci_ids.h
@@ -495,6 +495,8 @@
 
 #define PCI_VENDOR_ID_AMD		0x1022
 #define PCI_DEVICE_ID_AMD_K8_NB		0x1100
+#define PCI_DEVICE_ID_AMD_K8_NB_ADDRMAP	0x1101
+#define PCI_DEVICE_ID_AMD_K8_NB_MEMCTL	0x1102
 #define PCI_DEVICE_ID_AMD_K8_NB_MISC	0x1103
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch
