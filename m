From: akpm@osdl.org
Subject: + add-support-for-korenix-16c950-based-pci-cards-fix.patch added to -mm tree
Date: Wed, 13 Dec 2006 17:08:30 -0800
Message-ID: <200612140108.kBE18UEK027367@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36374 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbWLNBIy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 20:08:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rmk@arm.linux.org.uk


The patch titled
     add-support-for-korenix-16c950-based-pci-cards fix
has been added to the -mm tree.  Its filename is
     add-support-for-korenix-16c950-based-pci-cards-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add-support-for-korenix-16c950-based-pci-cards fix
From: Russell King <rmk@arm.linux.org.uk>



Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/pci_ids.h |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN include/linux/pci_ids.h~add-support-for-korenix-16c950-based-pci-cards-fix include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~add-support-for-korenix-16c950-based-pci-cards-fix
+++ a/include/linux/pci_ids.h
@@ -2067,6 +2067,10 @@
 #define PCI_DEVICE_ID_JMICRON_JMB366	0x2366
 #define PCI_DEVICE_ID_JMICRON_JMB368	0x2368
 
+#define PCI_VENDOR_ID_KORENIX		0x1982
+#define PCI_DEVICE_ID_KORENIX_JETCARDF0	0x1600
+#define PCI_DEVICE_ID_KORENIX_JETCARDF1	0x16ff
+
 #define PCI_VENDOR_ID_TEKRAM		0x1de1
 #define PCI_DEVICE_ID_TEKRAM_DC290	0xdc29
 
_

Patches currently in -mm which might be from rmk@arm.linux.org.uk are

origin.patch
fix-more-workqueue-build-breakage-tps65010.patch
another-build-fix-header-rearrangements-osk.patch
pm-fix-smp-races-in-the-freezer.patch
getting-rid-of-all-casts-of-kalloc-calls.patch
add-support-for-korenix-16c950-based-pci-cards-fix.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
8250-uart-backup-timer.patch
serial-trivial-code-flow-simplification.patch
make-sure-uart-is-powered-up-when-dumping-mctrl-status.patch
perle-multimodem-card-pci-ras-detection.patch
pnx8550-uart-driver.patch
workstruct-implement-generic-up-cmpxchg-where-an-arch-doesnt-support-it.patch

