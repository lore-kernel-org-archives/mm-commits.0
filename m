From: akpm@linux-foundation.org
Subject: + fix-typo-in-include-linux-pcih.patch added to -mm tree
Date: Thu, 12 Jul 2007 16:09:40 -0700
Message-ID: <200707122309.l6CN9ech010021@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56655 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755447AbXGLXJ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jul 2007 19:09:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eike-kernel@sf-tec.de


The patch titled
     Fix typo in include/linux/pci.h
has been added to the -mm tree.  Its filename is
     fix-typo-in-include-linux-pcih.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-netdev-all.patch
fix-typo-in-include-linux-pcih.patch
mm-use-div_round_up-in-mm-memoryc.patch
