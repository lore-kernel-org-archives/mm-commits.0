From: akpm@linux-foundation.org
Subject: - fix-typo-in-include-linux-pcih.patch removed from -mm tree
Date: Fri, 24 Aug 2007 20:24:28 -0700
Message-ID: <200708250324.l7P3OSck028058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57050 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753016AbXHYDYi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 23:24:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eike-kernel@sf-tec.de, mm-commits@vger.kernel.org


The patch titled
     Fix typo in include/linux/pci.h
has been removed from the -mm tree.  Its filename was
     fix-typo-in-include-linux-pcih.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: Fix typo in include/linux/pci.h
From: Rolf Eike Beer <eike-kernel@sf-tec.de>

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pci.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/pci.h~fix-typo-in-include-linux-pcih include/linux/pci.h
--- a/include/linux/pci.h~fix-typo-in-include-linux-pcih
+++ a/include/linux/pci.h
@@ -315,7 +315,7 @@ struct pci_dynids {
 
 /* ---------------------------------------------------------------- */
 /** PCI Error Recovery System (PCI-ERS).  If a PCI device driver provides
- *  a set fof callbacks in struct pci_error_handlers, then that device driver
+ *  a set of callbacks in struct pci_error_handlers, then that device driver
  *  will be notified of PCI bus errors, and will be driven to recovery
  *  when an error occurs.
  */
_

Patches currently in -mm which might be from eike-kernel@sf-tec.de are

origin.patch
git-dvb.patch
git-r8169.patch
