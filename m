From: akpm@linux-foundation.org
Subject: [folded] edac-amd8111-driver-header-file-v3.patch removed from -mm tree
Date: Thu, 02 Apr 2009 16:23:52 -0700
Message-ID: <200904022323.n32NNq6Y011975@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43508 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756120AbZDBXZp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2009 19:25:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qingtao.cao@windriver.com, norsk5@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     edac: AMD8111 driver header file
has been removed from the -mm tree.  Its filename was
     edac-amd8111-driver-header-file-v3.patch

This patch was dropped because it was folded into edac-amd8111-driver-header-file.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: AMD8111 driver header file
From: Harry Ciao <qingtao.cao@windriver.com>

Introduce AMD8111 EDAC driver header file, which adds register and bits
definitions for the LPC Bridge Controller and PCI Bridge Controller on
the AMD8111 HyperTransport I/O Hub.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/amd8111_edac.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/amd8111_edac.h~edac-amd8111-driver-header-file-v3 drivers/edac/amd8111_edac.h
--- a/drivers/edac/amd8111_edac.h~edac-amd8111-driver-header-file-v3
+++ a/drivers/edac/amd8111_edac.h
@@ -109,7 +109,7 @@ struct amd8111_dev_info {
 	u16 err_dev;	/* PCI Device ID */
 	struct pci_dev *dev;
 	int edac_idx;	/* device index */
-	const char *ctl_name;
+	char *ctl_name;
 	struct edac_device_ctl_info *edac_dev;
 	void (*init)(struct amd8111_dev_info *dev_info);
 	void (*exit)(struct amd8111_dev_info *dev_info);
_

Patches currently in -mm which might be from qingtao.cao@windriver.com are

edac-amd8111-driver-header-file.patch
edac-amd8111-driver-header-file-v3.patch
edac-amd8111-driver-source-file.patch
edac-amd8111-driver-source-file-v3.patch
edac-add-edac_pci_alloc_index.patch
pci-add-amd8111-pci-bridge-pci-device-id.patch
edac-amd8131-driver-header-file.patch
edac-amd8131-driver-source-file.patch
edac-amd8131-driver-source-file-v2.patch
edac-amd8131-driver-kconfig-makefile.patch
edac-amd8111-driver-kconfig-makefile.patch

