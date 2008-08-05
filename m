From: akpm@linux-foundation.org
Subject: + pciidsh-remove-a-duplicated-symbol.patch added to -mm tree
Date: Tue, 05 Aug 2008 14:07:53 -0700
Message-ID: <200808052107.m75L7rXA023541@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50636 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753707AbYHEVI3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 17:08:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: grant_lkml@dodo.com.au, dougthompson@xmission.com, gcoady.lk@gmail.com, jbarnes@virtuousgeek.org


The patch titled
     pci.ids.h: remove a duplicated symbol
has been added to the -mm tree.  Its filename is
     pciidsh-remove-a-duplicated-symbol.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci.ids.h: remove a duplicated symbol
From: Grant Coady <grant_lkml@dodo.com.au>

pci.ids.h: remove a duplicated symbol

Signed-off-by: Grant Coady <gcoady.lk@gmail.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pci_ids.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/pci_ids.h~pciidsh-remove-a-duplicated-symbol include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~pciidsh-remove-a-duplicated-symbol
+++ a/include/linux/pci_ids.h
@@ -2177,8 +2177,6 @@
 #define PCI_DEVICE_ID_HERC_WIN		0x5732
 #define PCI_DEVICE_ID_HERC_UNI		0x5832
 
-#define PCI_VENDOR_ID_RDC		0x17f3
