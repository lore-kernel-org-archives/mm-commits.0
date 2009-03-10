From: akpm@linux-foundation.org
Subject: + pci-add-amd8111-pci-bridge-pci-device-id.patch added to -mm tree
Date: Tue, 10 Mar 2009 13:47:24 -0700
Message-ID: <200903102047.n2AKlOPA003279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755340AbZCJUs1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Mar 2009 16:48:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qingtao.cao@windriver.com, norsk5@yahoo.com


The patch titled
     pci: Add AMD8111 PCI Bridge PCI Device ID
has been added to the -mm tree.  Its filename is
     pci-add-amd8111-pci-bridge-pci-device-id.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: Add AMD8111 PCI Bridge PCI Device ID
From: Harry Ciao <qingtao.cao@windriver.com>

Add the PCI Device ID of the PCI Bridge Controller on AMD8111 chip.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pci_ids.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/pci_ids.h~pci-add-amd8111-pci-bridge-pci-device-id include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~pci-add-amd8111-pci-bridge-pci-device-id
+++ a/include/linux/pci_ids.h
@@ -526,6 +526,7 @@
 #define PCI_DEVICE_ID_AMD_OPUS_7443	0x7443
 #define PCI_DEVICE_ID_AMD_VIPER_7443	0x7443
 #define PCI_DEVICE_ID_AMD_OPUS_7445	0x7445
+#define PCI_DEVICE_ID_AMD_8111_PCI	0x7460
 #define PCI_DEVICE_ID_AMD_8111_LPC	0x7468
 #define PCI_DEVICE_ID_AMD_8111_IDE	0x7469
 #define PCI_DEVICE_ID_AMD_8111_SMBUS2	0x746a
_

Patches currently in -mm which might be from qingtao.cao@windriver.com are

edac-amd8111-driver-header-file.patch
edac-amd8111-driver-source-file.patch
edac-add-edac_pci_alloc_index.patch
pci-add-amd8111-pci-bridge-pci-device-id.patch
edac-amd8131-driver-header-file.patch
edac-amd8131-driver-source-file.patch
edac-amd8131-driver-kconfig-makefile.patch
edac-amd8111-driver-kconfig-makefile.patch

