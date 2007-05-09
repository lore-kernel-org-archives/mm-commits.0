From: akpm@linux-foundation.org
Subject: - i386-pci-type-may-be-unused.patch removed from -mm tree
Date: Wed, 09 May 2007 14:54:32 -0700
Message-ID: <200705092154.l49LsWV4003169@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758502AbXEIVzK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:55:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386 pci: use __maybe_unused
has been removed from the -mm tree.  Its filename was
     i386-pci-type-may-be-unused.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386 pci: use __maybe_unused
From: David Rientjes <rientjes@google.com>

Use the new macro here

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/pci/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/pci/init.c~i386-pci-type-may-be-unused arch/i386/pci/init.c
--- a/arch/i386/pci/init.c~i386-pci-type-may-be-unused
+++ a/arch/i386/pci/init.c
@@ -6,7 +6,7 @@
    in the right sequence from here. */
 static __init int pci_access_init(void)
 {
-	int type __attribute__((unused)) = 0;
+	int type __maybe_unused = 0;
 
 #ifdef CONFIG_PCI_DIRECT
 	type = pci_direct_probe();
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
git-alsa.patch
powerpc-ps3-use-__maybe_unused.patch
mips-excite-use-__maybe_unused.patch
mips-tlbex-use-__maybe_unused.patch
scsi-fix-ambiguous-gdthtable-definition.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
frv-gdb-use-__maybe_unused.patch
