From: akpm@linux-foundation.org
Subject: + xen-fix-x86-config-dependencies.patch added to -mm tree
Date: Tue, 03 Jul 2007 11:26:52 -0700
Message-ID: <200707031826.l63IQqdi007788@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44939 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755711AbXGCS1L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 14:27:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, ak@suse.de, bunk@stusta.de, jeremy@xensource.com


The patch titled
     xen: fix x86 config dependencies
has been added to the -mm tree.  Its filename is
     xen-fix-x86-config-dependencies.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: xen: fix x86 config dependencies
From: Jeremy Fitzhardinge <jeremy@goop.org>

Make sure we set dependencies on CPU features.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Adrian Bunk <bunk@stusta.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/xen/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/xen/Kconfig~xen-fix-x86-config-dependencies arch/i386/xen/Kconfig
--- a/arch/i386/xen/Kconfig~xen-fix-x86-config-dependencies
+++ a/arch/i386/xen/Kconfig
@@ -4,7 +4,7 @@
 
 config XEN
 	bool "Enable support for Xen hypervisor"
-	depends on PARAVIRT
+	depends on PARAVIRT && X86_CMPXCHG && X86_TSC
 	help
 	  This is the Linux Xen port.  Enabling this will allow the
 	  kernel to boot in a paravirtualized environment under the
_

Patches currently in -mm which might be from jeremy@goop.org are

i386-fix-regression-endless-loop-in-ptrace-singlestep.patch
git-kbuild.patch
add-kstrndup-fix.patch
xen-build-fix.patch
fix-x86_64-mm-xen-xen-smp-guest-support.patch
more-fix-x86_64-mm-xen-xen-smp-guest-support.patch
fix-x86_64-mm-xen-add-xen-virtual-block-device-driver.patch
fix-x86_64-mm-add-common-orderly_poweroff.patch
tidy-up-usermode-helper-waiting-a-bit-fix.patch
update-x86_64-mm-xen-use-iret-directly-where-possible.patch
x86-use-elfnoteh-to-generate-vsyscall-notes-fix.patch
paravirt-helper-to-disable-all-io-space-fix-2.patch
paravirt-helper-to-disable-all-io-space-fix-3.patch
i386-minor-nx-handling-adjustment-fix.patch
xen-fix-x86-config-dependencies.patch
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
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
generic-bug-use-show_regs-instead-of-dump_stack.patch
lguest-the-guest-code.patch
