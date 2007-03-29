From: akpm@linux-foundation.org
Subject: - clarify-config_reorder-explanation.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:38:56 -0700
Message-ID: <200703292338.l2TNcuWI015390@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43154 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934395AbXC2XjD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:39:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     Clarify CONFIG_REORDER explanation
has been removed from the -mm tree.  Its filename was
     clarify-config_reorder-explanation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Clarify CONFIG_REORDER explanation
From: Rusty Russell <rusty@rustcorp.com.au>

if (1 && X) => if (X).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86_64/Kconfig~clarify-config_reorder-explanation arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~clarify-config_reorder-explanation
+++ a/arch/x86_64/Kconfig
@@ -632,8 +632,8 @@ config REORDER
 	default n
 	help
          This option enables the toolchain to reorder functions for a more 
-         optimal TLB usage. If you have pretty much any version of binutils, 
-	 this can increase your kernel build time by roughly one minute.
+         optimal TLB usage.  This will slow your kernel build by
+	 roughly one minute.
 
 config K8_NB
 	def_bool y
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
git-net.patch
allow-per-cpu-variables-to-be-page-aligned.patch
array_size-check-for-type.patch
array_size-check-for-type-uml-fix.patch
module-use-krealloc.patch
extend-print_symbol-capability.patch
extend-print_symbol-capability-fix.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
____call_usermodehelper-dont-flush_signals.patch
