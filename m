From: akpm@linux-foundation.org
Subject: + paravirt-helper-to-disable-all-io-space-fix-3.patch added to -mm tree
Date: Wed, 06 Jun 2007 19:06:22 -0700
Message-ID: <200706070206.l5726MbF018492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42505 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935334AbXFGCGa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2007 22:06:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, jeremy@xensource.com


The patch titled
     xen: don't include unnecessary headers
has been added to the -mm tree.  Its filename is
     paravirt-helper-to-disable-all-io-space-fix-3.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: xen: don't include unnecessary headers
From: Jeremy Fitzhardinge <jeremy@goop.org>

Strays left over from the first implementation of
paravirt_disable_iospace().

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/xen/setup.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN arch/i386/xen/setup.c~paravirt-helper-to-disable-all-io-space-fix-3 arch/i386/xen/setup.c
--- a/arch/i386/xen/setup.c~paravirt-helper-to-disable-all-io-space-fix-3
+++ a/arch/i386/xen/setup.c
@@ -8,14 +8,12 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 #include <linux/pm.h>
-#include <linux/ioport.h>
 
 #include <asm/elf.h>
 #include <asm/e820.h>
 #include <asm/setup.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
-#include <asm/io.h>
 
 #include <xen/interface/physdev.h>
 #include <xen/features.h>
_

Patches currently in -mm which might be from jeremy@goop.org are

git-kbuild.patch
add-kstrndup-fix.patch
xen-build-fix.patch
fix-x86_64-mm-xen-xen-smp-guest-support.patch
fix-x86_64-mm-xen-core-xen-implementation.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch
paravirt-helper-to-disable-all-io-space-fix-2.patch
paravirt-helper-to-disable-all-io-space-fix-3.patch
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
tidy-up-usermode-helper-waiting-a-bit-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
lguest-the-guest-code.patch
