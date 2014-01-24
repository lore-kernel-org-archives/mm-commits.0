From: akpm@linux-foundation.org
Subject: [merged]
 kconfig-update-flightly-outdated-config_smp-documentation.patch removed
 from -mm tree
Date: Fri, 24 Jan 2014 11:03:20 -0800
Message-ID: <52e2b8f8.8Xk0G/V60N5lVTmq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbaAXTDU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:03:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, psquid@psquid.net

Subject: [merged] kconfig-update-flightly-outdated-config_smp-documentation.patch removed from -mm tree
To: psquid@psquid.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:03:20 -0800


The patch titled
     Subject: Kconfig: update flightly outdated CONFIG_SMP documentation
has been removed from the -mm tree.  Its filename was
     kconfig-update-flightly-outdated-config_smp-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Robert Graffham <psquid@psquid.net>
Subject: Kconfig: update flightly outdated CONFIG_SMP documentation

Remove an outdated reference to "most personal computers" having only one
CPU, and change the use of "singleprocessor" and "single processor" in
CONFIG_SMP's documentation to "uniprocessor" across all arches where that
documentation is present.

Signed-off-by: Robert Graffham <psquid@psquid.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig   |    8 ++++----
 arch/arc/Kconfig     |    4 ++--
 arch/arm/Kconfig     |   12 ++++++------
 arch/m32r/Kconfig    |    8 ++++----
 arch/mips/Kconfig    |    8 ++++----
 arch/mn10300/Kconfig |    8 ++++----
 arch/parisc/Kconfig  |    8 ++++----
 arch/s390/Kconfig    |    4 ++--
 arch/sh/Kconfig      |    8 ++++----
 arch/sparc/Kconfig   |    4 ++--
 arch/x86/Kconfig     |    8 ++++----
 11 files changed, 40 insertions(+), 40 deletions(-)

diff -puN arch/alpha/Kconfig~kconfig-update-flightly-outdated-config_smp-documentation arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~kconfig-update-flightly-outdated-config_smp-documentation
+++ a/arch/alpha/Kconfig
@@ -539,13 +539,13 @@ config SMP
 	depends on ALPHA_SABLE || ALPHA_LYNX || ALPHA_RAWHIDE || ALPHA_DP264 || ALPHA_WILDFIRE || ALPHA_TITAN || ALPHA_GENERIC || ALPHA_SHARK || ALPHA_MARVEL
 	---help---
 	  This enables support for systems with more than one CPU. If you have
-	  a system with only one CPU, like most personal computers, say N. If
-	  you have a system with more than one CPU, say Y.
+	  a system with only one CPU, say N. If you have a system with more
+	  than one CPU, say Y.
 
-	  If you say N here, the kernel will run on single and multiprocessor
+	  If you say N here, the kernel will run on uni- and multiprocessor
 	  machines, but will use only one CPU of a multiprocessor machine. If
 	  you say Y here, the kernel will run on many, but not all,
-	  singleprocessor machines. On a singleprocessor machine, the kernel
+	  uniprocessor machines. On a uniprocessor machine, the kernel
 	  will run faster if you say N here.
 
 	  See also the SMP-HOWTO available at
diff -puN arch/arc/Kconfig~kconfig-update-flightly-outdated-config_smp-documentation arch/arc/Kconfig
--- a/arch/arc/Kconfig~kconfig-update-flightly-outdated-config_smp-documentation
+++ a/arch/arc/Kconfig
@@ -128,8 +128,8 @@ config SMP
 	default n
 	help
 	  This enables support for systems with more than one CPU. If you have
-	  a system with only one CPU, like most personal computers, say N. If
-	  you have a system with more than one CPU, say Y.
+	  a system with only one CPU, say N. If you have a system with more
+	  than one CPU, say Y.
 
 if SMP
 
diff -puN arch/arm/Kconfig~kconfig-update-flightly-outdated-config_smp-documentation arch/arm/Kconfig
--- a/arch/arm/Kconfig~kconfig-update-flightly-outdated-config_smp-documentation
+++ a/arch/arm/Kconfig
@@ -1435,14 +1435,14 @@ config SMP
 	depends on MMU || ARM_MPU
 	help
 	  This enables support for systems with more than one CPU. If you have
-	  a system with only one CPU, like most personal computers, say N. If
-	  you have a system with more than one CPU, say Y.
+	  a system with only one CPU, say N. If you have a system with more
+	  than one CPU, say Y.
 
-	  If you say N here, the kernel will run on single and multiprocessor
+	  If you say N here, the kernel will run on uni- and multiprocessor
 	  machines, but will use only one CPU of a multiprocessor machine. If
-	  you say Y here, the kernel will run on many, but not all, single
-	  processor machines. On a single processor machine, the kernel will
-	  run faster if you say N here.
+	  you say Y here, the kernel will run on many, but not all,
+	  uniprocessor machines. On a uniprocessor machine, the kernel
+	  will run faster if you say N here.
 
 	  See also <file:Documentation/x86/i386/IO-APIC.txt>,
 	  <file:Documentation/nmi_watchdog.txt> and the SMP-HOWTO available at
diff -puN arch/m32r/Kconfig~kconfig-update-flightly-outdated-config_smp-documentation arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~kconfig-update-flightly-outdated-config_smp-documentation
+++ a/arch/m32r/Kconfig
@@ -277,13 +277,13 @@ config SMP
 	bool "Symmetric multi-processing support"
 	---help---
 	  This enables support for systems with more than one CPU. If you have
-	  a system with only one CPU, like most personal computers, say N. If
-	  you have a system with more than one CPU, say Y.
+	  a system with only one CPU, say N. If you have a system with more
+	  than one CPU, say Y.
 
-	  If you say N here, the kernel will run on single and multiprocessor
+	  If you say N here, the kernel will run on uni- and multiprocessor
 	  machines, but will use only one CPU of a multiprocessor machine. If
 	  you say Y here, the kernel will run on many, but not all,
-	  singleprocessor machines. On a singleprocessor machine, the kernel
+	  uniprocessor machines. On a uniprocessor machine, the kernel
 	  will run faster if you say N here.
 
 	  People using multiprocessor machines who say Y here should also say
diff -puN arch/mips/Kconfig~kconfig-update-flightly-outdated-config_smp-documentation arch/mips/Kconfig
--- a/arch/mips/Kconfig~kconfig-update-flightly-outdated-config_smp-documentation
+++ a/arch/mips/Kconfig
@@ -2129,13 +2129,13 @@ config SMP
 	depends on SYS_SUPPORTS_SMP
 	help
 	  This enables support for systems with more than one CPU. If you have
-	  a system with only one CPU, like most personal computers, say N. If
-	  you have a system with more than one CPU, say Y.
+	  a system with only one CPU, say N. If you have a system with more
+	  than one CPU, say Y.
 
-	  If you say N here, the kernel will run on single and multiprocessor
+	  If you say N here, the kernel will run on uni- and multiprocessor
 	  machines, but will use only one CPU of a multiprocessor machine. If
 	  you say Y here, the kernel will run on many, but not all,
-	  singleprocessor machines. On a singleprocessor machine, the kernel
+	  uniprocessor machines. On a uniprocessor machine, the kernel
 	  will run faster if you say N here.
 
 	  People using multiprocessor machines who say Y here should also say
diff -puN arch/mn10300/Kconfig~kconfig-update-flightly-outdated-config_smp-documentation arch/mn10300/Kconfig
--- a/arch/mn10300/Kconfig~kconfig-update-flightly-outdated-config_smp-documentation
+++ a/arch/mn10300/Kconfig
@@ -184,13 +184,13 @@ config SMP
 	depends on MN10300_PROC_MN2WS0038 || MN10300_PROC_MN2WS0050
 	---help---
 	  This enables support for systems with more than one CPU. If you have
-	  a system with only one CPU, like most personal computers, say N. If
-	  you have a system with more than one CPU, say Y.
+	  a system with only one CPU, say N. If you have a system with more
+	  than one CPU, say Y.
 
-	  If you say N here, the kernel will run on single and multiprocessor
+	  If you say N here, the kernel will run on uni- and multiprocessor
 	  machines, but will use only one CPU of a multiprocessor machine. If
 	  you say Y here, the kernel will run on many, but not all,
-	  singleprocessor machines. On a singleprocessor machine, the kernel
+	  uniprocessor machines. On a uniprocessor machine, the kernel
 	  will run faster if you say N here.
 
 	  See also <file:Documentation/x86/i386/IO-APIC.txt>,
diff -puN arch/parisc/Kconfig~kconfig-update-flightly-outdated-config_smp-documentation arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~kconfig-update-flightly-outdated-config_smp-documentation
+++ a/arch/parisc/Kconfig
@@ -229,13 +229,13 @@ config SMP
 	bool "Symmetric multi-processing support"
 	---help---
 	  This enables support for systems with more than one CPU. If you have
-	  a system with only one CPU, like most personal computers, say N. If
-	  you have a system with more than one CPU, say Y.
+	  a system with only one CPU, say N. If you have a system with more
+	  than one CPU, say Y.
 
-	  If you say N here, the kernel will run on single and multiprocessor
+	  If you say N here, the kernel will run on uni- and multiprocessor
 	  machines, but will use only one CPU of a multiprocessor machine. If
 	  you say Y here, the kernel will run on many, but not all,
-	  singleprocessor machines. On a singleprocessor machine, the kernel
+	  uniprocessor machines. On a uniprocessor machine, the kernel
 	  will run faster if you say N here.
 
 	  See also <file:Documentation/nmi_watchdog.txt> and the SMP-HOWTO
diff -puN arch/s390/Kconfig~kconfig-update-flightly-outdated-config_smp-documentation arch/s390/Kconfig
--- a/arch/s390/Kconfig~kconfig-update-flightly-outdated-config_smp-documentation
+++ a/arch/s390/Kconfig
@@ -334,10 +334,10 @@ config SMP
 	  a system with only one CPU, like most personal computers, say N. If
 	  you have a system with more than one CPU, say Y.
 
-	  If you say N here, the kernel will run on single and multiprocessor
+	  If you say N here, the kernel will run on uni- and multiprocessor
 	  machines, but will use only one CPU of a multiprocessor machine. If
 	  you say Y here, the kernel will run on many, but not all,
-	  singleprocessor machines. On a singleprocessor machine, the kernel
+	  uniprocessor machines. On a uniprocessor machine, the kernel
 	  will run faster if you say N here.
 
 	  See also the SMP-HOWTO available at
diff -puN arch/sh/Kconfig~kconfig-update-flightly-outdated-config_smp-documentation arch/sh/Kconfig
--- a/arch/sh/Kconfig~kconfig-update-flightly-outdated-config_smp-documentation
+++ a/arch/sh/Kconfig
@@ -701,13 +701,13 @@ config SMP
 	depends on SYS_SUPPORTS_SMP
 	---help---
 	  This enables support for systems with more than one CPU. If you have
-	  a system with only one CPU, like most personal computers, say N. If
-	  you have a system with more than one CPU, say Y.
+	  a system with only one CPU, say N. If you have a system with more
+	  than one CPU, say Y.
 
-	  If you say N here, the kernel will run on single and multiprocessor
+	  If you say N here, the kernel will run on uni- and multiprocessor
 	  machines, but will use only one CPU of a multiprocessor machine. If
 	  you say Y here, the kernel will run on many, but not all,
-	  singleprocessor machines. On a singleprocessor machine, the kernel
+	  uniprocessor machines. On a uniprocessor machine, the kernel
 	  will run faster if you say N here.
 
 	  People using multiprocessor machines who say Y here should also say
diff -puN arch/sparc/Kconfig~kconfig-update-flightly-outdated-config_smp-documentation arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~kconfig-update-flightly-outdated-config_smp-documentation
+++ a/arch/sparc/Kconfig
@@ -152,10 +152,10 @@ config SMP
 	  a system with only one CPU, say N. If you have a system with more
 	  than one CPU, say Y.
 
-	  If you say N here, the kernel will run on single and multiprocessor
+	  If you say N here, the kernel will run on uni- and multiprocessor
 	  machines, but will use only one CPU of a multiprocessor machine. If
 	  you say Y here, the kernel will run on many, but not all,
-	  singleprocessor machines. On a singleprocessor machine, the kernel
+	  uniprocessor machines. On a uniprocessor machine, the kernel
 	  will run faster if you say N here.
 
 	  People using multiprocessor machines who say Y here should also say
diff -puN arch/x86/Kconfig~kconfig-update-flightly-outdated-config_smp-documentation arch/x86/Kconfig
--- a/arch/x86/Kconfig~kconfig-update-flightly-outdated-config_smp-documentation
+++ a/arch/x86/Kconfig
@@ -279,13 +279,13 @@ config SMP
 	bool "Symmetric multi-processing support"
 	---help---
 	  This enables support for systems with more than one CPU. If you have
-	  a system with only one CPU, like most personal computers, say N. If
-	  you have a system with more than one CPU, say Y.
+	  a system with only one CPU, say N. If you have a system with more
+	  than one CPU, say Y.
 
-	  If you say N here, the kernel will run on single and multiprocessor
+	  If you say N here, the kernel will run on uni- and multiprocessor
 	  machines, but will use only one CPU of a multiprocessor machine. If
 	  you say Y here, the kernel will run on many, but not all,
-	  singleprocessor machines. On a singleprocessor machine, the kernel
+	  uniprocessor machines. On a uniprocessor machine, the kernel
 	  will run faster if you say N here.
 
 	  Note that if you say Y here and choose architecture "586" or
_

Patches currently in -mm which might be from psquid@psquid.net are

origin.patch

