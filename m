From: akpm@linux-foundation.org
Subject: - uml-smp-needs-to-depend-on-broken-for-now.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:35:44 -0800
Message-ID: <200802052235.m15MZPUv012611@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51768 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762271AbYBEWlO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: SMP needs to depend on BROKEN for now
has been removed from the -mm tree.  Its filename was
     uml-smp-needs-to-depend-on-broken-for-now.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
