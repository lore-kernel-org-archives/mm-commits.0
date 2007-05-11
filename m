From: akpm@linux-foundation.org
Subject: + mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-update.patch added to -mm tree
Date: Fri, 11 May 2007 14:49:08 -0700
Message-ID: <200705112149.l4BLn8qX027721@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751349AbXEKVtQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 17:49:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adurbin@google.com, ak@suse.de, rientjes@google.com


The patch titled
     mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources update
has been added to the -mm tree.  Its filename is
     mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources update
From: Aaron Durbin <adurbin@google.com>

Updated to reflect comments from rientjes@google.com.

Signed-off-by: Aaron Durbin <adurbin@google.com>
Cc: Aaron Durbin <adurbin@google.com>
Cc: Andi Kleen <ak@suse.de>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/pci/mmconfig-shared.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/pci/mmconfig-shared.c~mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-update arch/i386/pci/mmconfig-shared.c
--- a/arch/i386/pci/mmconfig-shared.c~mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-update
+++ a/arch/i386/pci/mmconfig-shared.c
@@ -173,7 +173,7 @@ static int __init pci_mmcfg_check_hostbr
 	return name != NULL;
 }
 
-static void __init pci_mmcfg_insert_resources(int resource_flags)
+static void __init pci_mmcfg_insert_resources(unsigned long resource_flags)
 {
 #define PCI_MMCFG_RESOURCE_NAME_LEN 19
 	int i;
_

Patches currently in -mm which might be from adurbin@google.com are

mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-fix.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources-update.patch
