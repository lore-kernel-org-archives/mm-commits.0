From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-kconfig-menus-update.patch removed from -mm tree
Date: Thu, 10 May 2007 15:32:04 -0700
Message-ID: <200705102232.l4AMW4Yb032586@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40159 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751856AbXEJWcM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 18:32:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     linux-kernel-markers-kconfig-menus update
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-kconfig-menus-update.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: linux-kernel-markers-kconfig-menus update
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/Kconfig.debug |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN arch/avr32/Kconfig.debug~linux-kernel-markers-kconfig-menus-update arch/avr32/Kconfig.debug
--- a/arch/avr32/Kconfig.debug~linux-kernel-markers-kconfig-menus-update
+++ a/arch/avr32/Kconfig.debug
@@ -6,6 +6,9 @@ config TRACE_IRQFLAGS_SUPPORT
 
 source "lib/Kconfig.debug"
 
+menu "Instrumentation Support"
+	depends on EXPERIMENTAL
+
 config KPROBES
 	bool "Kprobes"
 	depends on DEBUG_KERNEL
@@ -17,4 +20,8 @@ config KPROBES
           for kernel debugging, non-intrusive instrumentation and testing.
           If in doubt, say "N".
 
+source "kernel/Kconfig.marker"
+
+endmenu
+
 endmenu
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
git-avr32.patch
powerpc-promc-remove-undef-printk.patch
linux-kernel-markers-kconfig-menus-update.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-architecture-independant-code-update.patch
linux-kernel-markers-architecture-independant-code-update-fix.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-powerpc-optimization-update.patch
linux-kernel-markers-powerpc-optimization-fix.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-i386-optimization-update.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-non-optimized-architectures-update.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-update.patch
markers-define-the-linker-macro-extra_rwdata.patch
markers-use-extra_rwdata-in-architectures.patch
port-of-blktrace-to-the-linux-kernel-markers.patch
