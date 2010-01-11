From: akpm@linux-foundation.org
Subject: [merged] mn10300-use-kern_err-not-kern_error.patch removed from -mm tree
Date: Mon, 11 Jan 2010 12:19:29 -0800
Message-ID: <201001112019.o0BKJTmd025575@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34423 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752220Ab0AKU2n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jan 2010 15:28:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mn10300: use KERN_ERR not KERN_ERROR
has been removed from the -mm tree.  Its filename was
     mn10300-use-kern_err-not-kern_error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mn10300: use KERN_ERR not KERN_ERROR
From: David Howells <dhowells@redhat.com>

Use KERN_ERR not KERN_ERROR in the ASB2305 platform code.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/unit-asb2305/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/mn10300/unit-asb2305/pci.c~mn10300-use-kern_err-not-kern_error arch/mn10300/unit-asb2305/pci.c
--- a/arch/mn10300/unit-asb2305/pci.c~mn10300-use-kern_err-not-kern_error
+++ a/arch/mn10300/unit-asb2305/pci.c
@@ -279,7 +279,7 @@ static int __init pci_sanity_check(struc
 	     (x == PCI_VENDOR_ID_INTEL || x == PCI_VENDOR_ID_COMPAQ)))
 		return 1;
 
-	printk(KERN_ERROR "PCI: Sanity check failed\n");
+	printk(KERN_ERR "PCI: Sanity check failed\n");
 	return 0;
 }
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
kernel-credc-use-kmem_cache_free.patch
frv-duplicate-output_buffer-of-e03.patch
coredump-unify-dump_seek-implementations-for-each-binfmt_c.patch
coredump-move-dump_write-and-dump_seek-into-a-header-file.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions.patch
elf-coredump-make-offset-calculation-process-and-writing-process-explicit.patch
elf-coredump-add-extended-numbering-support.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

