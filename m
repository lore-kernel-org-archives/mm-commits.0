From: akpm@linux-foundation.org
Subject: - kconfig-make-instrumentation-support-non-experimental.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:53:17 -0700
Message-ID: <200710180653.l9I6rHOf030426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59676 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761552AbXJRHrU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:47:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, ak@suse.de, benh@kernel.crashing.org, davem@davemloft.net, paulus@samba.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     KCONFIG: Make "Instrumentation support" non-EXPERIMENTAL
has been removed from the -mm tree.  Its filename was
     kconfig-make-instrumentation-support-non-experimental.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1256,7 +1256,6 @@ source "fs/Kconfig"
 
 menuconfig INSTRUMENTATION
 	bool "Instrumentation Support"
-	depends on EXPERIMENTAL
 	default y
 	---help---
 	  Say Y here to get to see options related to performance measurement,
diff -puN arch/ia64/Kconfig~kconfig-make-instrumentation-support-non-experimental arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~kconfig-make-instrumentation-support-non-experimental
+++ a/arch/ia64/Kconfig
@@ -593,7 +593,6 @@ config IRQ_PER_CPU
 source "arch/ia64/hp/sim/Kconfig"
 
 menu "Instrumentation Support"
-        depends on EXPERIMENTAL
 
 source "arch/ia64/oprofile/Kconfig"
 
diff -puN arch/powerpc/Kconfig~kconfig-make-instrumentation-support-non-experimental arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~kconfig-make-instrumentation-support-non-experimental
+++ a/arch/powerpc/Kconfig
@@ -670,7 +670,6 @@ source "arch/powerpc/sysdev/qe_lib/Kconf
 source "lib/Kconfig"
 
 menu "Instrumentation Support"
-	depends on EXPERIMENTAL
 
 source "arch/powerpc/oprofile/Kconfig"
 
diff -puN arch/sparc/Kconfig~kconfig-make-instrumentation-support-non-experimental arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~kconfig-make-instrumentation-support-non-experimental
+++ a/arch/sparc/Kconfig
@@ -321,7 +321,6 @@ endmenu
 source "fs/Kconfig"
 
 menu "Instrumentation Support"
-	depends on EXPERIMENTAL
 
 source "arch/sparc/oprofile/Kconfig"
 
diff -puN arch/sparc64/Kconfig~kconfig-make-instrumentation-support-non-experimental arch/sparc64/Kconfig
--- a/arch/sparc64/Kconfig~kconfig-make-instrumentation-support-non-experimental
+++ a/arch/sparc64/Kconfig
@@ -461,7 +461,6 @@ source "drivers/fc4/Kconfig"
 source "fs/Kconfig"
 
 menu "Instrumentation Support"
-        depends on EXPERIMENTAL
 
 source "arch/sparc64/oprofile/Kconfig"
 
diff -puN arch/x86_64/Kconfig~kconfig-make-instrumentation-support-non-experimental arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~kconfig-make-instrumentation-support-non-experimental
+++ a/arch/x86_64/Kconfig
@@ -796,7 +796,6 @@ source "drivers/firmware/Kconfig"
 source fs/Kconfig
 
 menu "Instrumentation Support"
-        depends on EXPERIMENTAL
 
 source "arch/x86/oprofile/Kconfig"
 
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-kvm.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
