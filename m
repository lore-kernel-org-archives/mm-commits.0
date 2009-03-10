From: akpm@linux-foundation.org
Subject: + edac-amd8111-driver-kconfig-makefile.patch added to -mm tree
Date: Tue, 10 Mar 2009 13:47:38 -0700
Message-ID: <200903102047.n2AKlc66003299@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56854 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755360AbZCJUsl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Mar 2009 16:48:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qingtao.cao@windriver.com, norsk5@yahoo.com


The patch titled
     edac: AMD8111 driver Kconfig & Makefile
has been added to the -mm tree.  Its filename is
     edac-amd8111-driver-kconfig-makefile.patch

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
Subject: edac: AMD8111 driver Kconfig & Makefile
From: Harry Ciao <qingtao.cao@windriver.com>

Introduce Kconfig and Makefile options for AMD8111 EDAC driver.

Signed-off-by: Harry Ciao <qingtao.cao@windriver.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/Kconfig |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/edac/Kconfig~edac-amd8111-driver-kconfig-makefile drivers/edac/Kconfig
--- a/drivers/edac/Kconfig~edac-amd8111-driver-kconfig-makefile
+++ a/drivers/edac/Kconfig
@@ -197,4 +197,11 @@ config EDAC_AMD8131
 	  Support for error detection and correction on the
 	  AMD8131 HyperTransport PCI-X Tunnel chip.
 
+config EDAC_AMD8111
+	tristate "AMD8111 HyperTransport I/O Hub"
+	depends on EDAC_MM_EDAC && PCI
+	help
+	  Support for error detection and correction on the
+	  AMD8111 HyperTransport I/O Hub chip.
+
 endif # EDAC
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

