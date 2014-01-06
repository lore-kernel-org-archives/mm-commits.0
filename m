From: akpm@linux-foundation.org
Subject: + kconfig-update-flightly-outdated-config_smp-documentation.patch added to -mm tree
Date: Mon, 06 Jan 2014 15:25:32 -0800
Message-ID: <52cb3b6c.eYpcGBpWHHJ1yooH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933138AbaAFXZd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jan 2014 18:25:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, psquid@psquid.net

Subject: + kconfig-update-flightly-outdated-config_smp-documentation.patch added to -mm tree
To: psquid@psquid.net
From: akpm@linux-foundation.org
Date: Mon, 06 Jan 2014 15:25:32 -0800


The patch titled
     Subject: Kconfig: update flightly outdated CONFIG_SMP documentation
has been added to the -mm tree.  Its filename is
     kconfig-update-flightly-outdated-config_smp-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kconfig-update-flightly-outdated-config_smp-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kconfig-update-flightly-outdated-config_smp-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1436,14 +1436,14 @@ config SMP
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

kconfig-update-flightly-outdated-config_smp-documentation.patch

