From: akpm@linux-foundation.org
Subject: + kconfig-make-instrumentation-support-non-experimental.patch added to -mm tree
Date: Thu, 19 Jul 2007 17:29:05 -0700
Message-ID: <200707200029.l6K0T59L030808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35593 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758749AbXGTA3U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 20:29:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, ak@suse.de, benh@kernel.crashing.org, davem@davemloft.net, paulus@samba.org, tony.luck@intel.com


The patch titled
     KCONFIG: Make "Instrumentation support" non-EXPERIMENTAL
has been added to the -mm tree.  Its filename is
     kconfig-make-instrumentation-support-non-experimental.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KCONFIG: Make "Instrumentation support" non-EXPERIMENTAL
From: "Robert P. J. Day" <rpjday@mindspring.com>

It makes more sense to make instrumentation support experimental on a
case-by-case basis.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig    |    1 -
 arch/ia64/Kconfig    |    1 -
 arch/powerpc/Kconfig |    1 -
 arch/sparc/Kconfig   |    1 -
 arch/sparc64/Kconfig |    1 -
 arch/x86_64/Kconfig  |    1 -
 6 files changed, 6 deletions(-)

diff -puN arch/i386/Kconfig~kconfig-make-instrumentation-support-non-experimental arch/i386/Kconfig
--- a/arch/i386/Kconfig~kconfig-make-instrumentation-support-non-experimental
+++ a/arch/i386/Kconfig
@@ -1242,7 +1242,6 @@ source "fs/Kconfig"
 
 menuconfig INSTRUMENTATION
 	bool "Instrumentation Support"
-	depends on EXPERIMENTAL
 	default y
 
 if INSTRUMENTATION
diff -puN arch/ia64/Kconfig~kconfig-make-instrumentation-support-non-experimental arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~kconfig-make-instrumentation-support-non-experimental
+++ a/arch/ia64/Kconfig
@@ -586,7 +586,6 @@ config IRQ_PER_CPU
 source "arch/ia64/hp/sim/Kconfig"
 
 menu "Instrumentation Support"
-        depends on EXPERIMENTAL
 
 source "arch/ia64/oprofile/Kconfig"
 
diff -puN arch/powerpc/Kconfig~kconfig-make-instrumentation-support-non-experimental arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~kconfig-make-instrumentation-support-non-experimental
+++ a/arch/powerpc/Kconfig
@@ -643,7 +643,6 @@ source "arch/powerpc/sysdev/qe_lib/Kconf
 source "lib/Kconfig"
 
 menu "Instrumentation Support"
-	depends on EXPERIMENTAL
 
 source "arch/powerpc/oprofile/Kconfig"
 
diff -puN arch/sparc/Kconfig~kconfig-make-instrumentation-support-non-experimental arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~kconfig-make-instrumentation-support-non-experimental
+++ a/arch/sparc/Kconfig
@@ -318,7 +318,6 @@ endmenu
 source "fs/Kconfig"
 
 menu "Instrumentation Support"
-	depends on EXPERIMENTAL
 
 source "arch/sparc/oprofile/Kconfig"
 
diff -puN arch/sparc64/Kconfig~kconfig-make-instrumentation-support-non-experimental arch/sparc64/Kconfig
--- a/arch/sparc64/Kconfig~kconfig-make-instrumentation-support-non-experimental
+++ a/arch/sparc64/Kconfig
@@ -465,7 +465,6 @@ source "drivers/fc4/Kconfig"
 source "fs/Kconfig"
 
 menu "Instrumentation Support"
-        depends on EXPERIMENTAL
 
 source "arch/sparc64/oprofile/Kconfig"
 
diff -puN arch/x86_64/Kconfig~kconfig-make-instrumentation-support-non-experimental arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~kconfig-make-instrumentation-support-non-experimental
+++ a/arch/x86_64/Kconfig
@@ -793,7 +793,6 @@ source "drivers/firmware/Kconfig"
 source fs/Kconfig
 
 menu "Instrumentation Support"
-        depends on EXPERIMENTAL
 
 source "arch/x86_64/oprofile/Kconfig"
 
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-alsa.patch
git-kbuild.patch
git-kvm.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
remove-dead-references-to-module_parm-macro.patch
i386-deactivate-the-test-for-the-dead-config_debug_page_type.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
ncp-delete-test-of-long-deceased-config_ncpfs_debugdentry.patch
kconfig-make-instrumentation-support-non-experimental.patch
