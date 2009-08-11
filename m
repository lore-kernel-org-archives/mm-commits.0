From: akpm@linux-foundation.org
Subject: [merged] mn10300-includecheck-fix-mn10300-pcih.patch removed from -mm tree
Date: Tue, 11 Aug 2009 12:58:18 -0700
Message-ID: <200908111958.n7BJwI1F022804@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752379AbZHKUAZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Aug 2009 16:00:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaswinder@kernel.org, dhowells@redhat.com, jaswinderrajput@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mn10300: includecheck fix: mn10300, pci.h
has been removed from the -mm tree.  Its filename was
     mn10300-includecheck-fix-mn10300-pcih.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mn10300: includecheck fix: mn10300, pci.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>

Fix the following 'make includecheck' warning:

  arch/mn10300/include/asm/pci.h: linux/mm.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/include/asm/pci.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/mn10300/include/asm/pci.h~mn10300-includecheck-fix-mn10300-pcih arch/mn10300/include/asm/pci.h
--- a/arch/mn10300/include/asm/pci.h~mn10300-includecheck-fix-mn10300-pcih
+++ a/arch/mn10300/include/asm/pci.h
@@ -59,7 +59,6 @@ void pcibios_penalize_isa_irq(int irq);
 #include <linux/slab.h>
 #include <asm/scatterlist.h>
 #include <linux/string.h>
-#include <linux/mm.h>
 #include <asm/io.h>
 
 struct pci_dev;
_

Patches currently in -mm which might be from jaswinder@kernel.org are

origin.patch
linux-next.patch
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
gitignore-usr-initramfs_datacpiobz2-and-usr-initramfs_datacpiolzma.patch
net-cs89x0-includecheck-fix-for-cs89x0c.patch
mm-includecheck-fix-for-mm-shmemc.patch
mm-includecheck-fix-for-mm-nommuc.patch

