From: akpm@linux-foundation.org
Subject: - use-extended-crashkernel-command-line-on-ppc64-update.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:33:44 -0700
Message-ID: <200710190433.l9J4XiSo015261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54749 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966597AbXJSEds (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:33:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, mm-commits@vger.kernel.org


The patch titled
     use-extended-crashkernel-command-line-on-ppc64 update
has been removed from the -mm tree.  Its filename was
     use-extended-crashkernel-command-line-on-ppc64-update.patch

This patch was dropped because it was folded into use-extended-crashkernel-command-line-on-ppc64.patch

------------------------------------------------------
Subject: use-extended-crashkernel-command-line-on-ppc64 update
From: Bernhard Walle <bwalle@suse.de>

This patch adapts the ppc64 code to use the generic parse_crashkernel()
function introduced in the generic patch of that series.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/machine_kexec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/kernel/machine_kexec.c~use-extended-crashkernel-command-line-on-ppc64-update arch/powerpc/kernel/machine_kexec.c
--- a/arch/powerpc/kernel/machine_kexec.c~use-extended-crashkernel-command-line-on-ppc64-update
+++ a/arch/powerpc/kernel/machine_kexec.c
@@ -63,7 +63,7 @@ NORET_TYPE void machine_kexec(struct kim
 
 void __init reserve_crashkernel(void)
 {
-	unsigned long long crash_size = 0, crash_base;
+	unsigned long long crash_size, crash_base;
 	int ret;
 
 	/* this is necessary because of lmb_phys_mem_size() */
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
extended-crashkernel-command-line.patch
use-extended-crashkernel-command-line-on-i386.patch
use-extended-crashkernel-command-line-on-x86_64.patch
use-extended-crashkernel-command-line-on-ia64.patch
use-extended-crashkernel-command-line-on-ppc64.patch
use-extended-crashkernel-command-line-on-ppc64-update.patch
use-extended-crashkernel-command-line-on-sh.patch
use-extended-crashkernel-command-line-on-sh-update.patch
add-documentation-for-extended-crashkernel-syntax.patch
add-documentation-for-extended-crashkernel-syntax-add-extended-crashkernel-syntax-to-kernel-parameterstxt.patch
