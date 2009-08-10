From: akpm@linux-foundation.org
Subject: + mn10300-includecheck-fix-mn10300-pcih.patch added to -mm tree
Date: Mon, 10 Aug 2009 14:47:16 -0700
Message-ID: <200908102147.n7ALlGCT007315@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753938AbZHJVtB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Aug 2009 17:49:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaswinder@kernel.org, dhowells@redhat.com, jaswinderrajput@gmail.com


The patch titled
     mn10300: includecheck fix: mn10300, pci.h
has been added to the -mm tree.  Its filename is
     mn10300-includecheck-fix-mn10300-pcih.patch

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
mn10300-includecheck-fix-mn10300-pcih.patch

