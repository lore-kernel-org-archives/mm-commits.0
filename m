From: akpm@linux-foundation.org
Subject: + uml-smp-needs-to-depend-on-broken-for-now.patch added to -mm tree
Date: Mon, 05 Nov 2007 18:29:11 -0800
Message-ID: <200711060229.lA62TBNY031845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55060 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754535AbXKFC3Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 21:29:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: SMP needs to depend on BROKEN for now
has been added to the -mm tree.  Its filename is
     uml-smp-needs-to-depend-on-broken-for-now.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: SMP needs to depend on BROKEN for now
From: Jeff Dike <jdike@addtoit.com>

SMP still needs to depend on BROKEN for now.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN arch/um/Kconfig~uml-smp-needs-to-depend-on-broken-for-now arch/um/Kconfig
--- a/arch/um/Kconfig~uml-smp-needs-to-depend-on-broken-for-now
+++ a/arch/um/Kconfig
@@ -189,8 +189,7 @@ config MAGIC_SYSRQ
 config SMP
 	bool "Symmetric multi-processing support (EXPERIMENTAL)"
 	default n
-	#SMP_BROKEN is for x86_64.
-	depends on EXPERIMENTAL && (!SMP_BROKEN || (BROKEN && SMP_BROKEN))
+	depends on BROKEN
 	help
 	  This option enables UML SMP support.
 	  It is NOT related to having a real SMP box. Not directly, at least.
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-correctly-strip-kernel-defines-from-userspace-cflags.patch
git-kvm.patch
uml-fix-spurious-irq-testing.patch
uml-remove-last-include-of-libc-asm-pageh.patch
uml-fix-build-for-config_tcp.patch
uml-fix-build-for-config_printk.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
