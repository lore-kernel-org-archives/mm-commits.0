From: akpm@linux-foundation.org
Subject: + clarify-config_reorder-explanation.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:52:01 -0800
Message-ID: <200703151852.l2FIq3DW023371@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35654 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337AbXCOSwL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:52:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, ak@suse.de


The patch titled
     Clarify CONFIG_REORDER explanation
has been added to the -mm tree.  Its filename is
     clarify-config_reorder-explanation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
i386-vdso_prelink-warning-fix.patch
cleanup-initialize-esp0-properly-all-the-time.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-kconfig-and-headers.patch
lguest-the-host-code-lgko.patch
lguest-the-host-code-lgko-cleanup-allocate-separate-pages-for-switcher-code.patch
lguest-the-host-code-lgko-cleanup-clean-up-regs-save-restore.patch
lguest-the-host-code-lgko-pin-stack-page-optimization.patch
lguest-guest-code.patch
lguest-makefile.patch
lguest-use-read-only-pages-rather-than-segments-to-protect-high-mapped-switcher.patch
lguest-optimize-away-copy-in-and-out-of-per-cpu-guest-pages.patch
lguest-dont-crash-host-on-nmi.patch
lguest-trivial-guest-network-driver.patch
lguest-trivial-guest-console-driver.patch
lguest-trivial-guest-block-driver.patch
lguest-trivial-guest-block-driver-lguest-block-device-speedup.patch
lguest-documentatation-and-example-launcher.patch
lguest-documentatation-and-example-launcher-bridging-support-in-example-code.patch
lguest-documentatation-and-example-launcher-bridging-support-in-example-codelguest-documentation-fixes.patch
introduce-load_tls-to-the-for-loop.patch
remove-unused-set_seg_base.patch
clarify-config_reorder-explanation.patch
module-use-krealloc.patch
extend-print_symbol-capability.patch
array_size-check-for-type.patch
____call_usermodehelper-dont-flush_signals.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-tidy.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
