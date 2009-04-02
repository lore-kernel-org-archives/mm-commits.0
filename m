From: akpm@linux-foundation.org
Subject: [folded] edac-amd8111-driver-source-file-v3.patch removed from -mm tree
Date: Thu, 02 Apr 2009 16:24:05 -0700
Message-ID: <200904022324.n32NO5so012028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759580AbZDBX0A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2009 19:26:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qingtao.cao@windriver.com, norsk5@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     edac: AMD8111 driver source file v3
has been removed from the -mm tree.  Its filename was
     edac-amd8111-driver-source-file-v3.patch

This patch was dropped because it was folded into edac-amd8111-driver-source-file.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: AMD8111 driver source file v3
From: Harry Ciao <qingtao.cao@windriver.com>

Introduce AMD8111 EDAC driver source file, which makes use of error
detections on the LPC Bridge Controller and PCI Bridge Controller on
the AMD8111 HyperTransport I/O Hub.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/amd8111_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/edac/amd8111_edac.c~edac-amd8111-driver-source-file-v3 drivers/edac/amd8111_edac.c
--- a/drivers/edac/amd8111_edac.c~edac-amd8111-driver-source-file-v3
+++ a/drivers/edac/amd8111_edac.c
@@ -24,10 +24,10 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include <linux/io.h>
 #include <linux/bitops.h>
 #include <linux/edac.h>
 #include <linux/pci_ids.h>
+#include <asm/io.h>
 
 #include "edac_core.h"
 #include "edac_module.h"
_

Patches currently in -mm which might be from qingtao.cao@windriver.com are

edac-amd8111-driver-header-file.patch
edac-amd8111-driver-source-file.patch
edac-amd8111-driver-source-file-v3.patch
edac-add-edac_pci_alloc_index.patch
pci-add-amd8111-pci-bridge-pci-device-id.patch
edac-amd8131-driver-header-file.patch
edac-amd8131-driver-source-file.patch
edac-amd8131-driver-source-file-v2.patch
edac-amd8131-driver-kconfig-makefile.patch
edac-amd8111-driver-kconfig-makefile.patch

