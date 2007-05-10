From: akpm@linux-foundation.org
Subject: - markers-add-instrumentation-markers-menus-to-avr32.patch removed from -mm tree
Date: Wed, 09 May 2007 20:37:35 -0700
Message-ID: <200705100337.l4A3bZtO011148@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753903AbXEJDhu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 23:37:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, hskinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     markers: add instrumentation/markers menus to avr32
has been removed from the -mm tree.  Its filename was
     markers-add-instrumentation-markers-menus-to-avr32.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: markers: add instrumentation/markers menus to avr32
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/Kconfig.debug |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN arch/avr32/Kconfig.debug~markers-add-instrumentation-markers-menus-to-avr32 arch/avr32/Kconfig.debug
--- a/arch/avr32/Kconfig.debug~markers-add-instrumentation-markers-menus-to-avr32
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
x86_64-fix-default_do_nmi-missing-return-after-a-if.patch
git-avr32.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-kconfig-menus-update.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-architecture-independant-code-update.patch
allow-userspace-applications-to-use-markerh-to-parse-the-markers-section-in-the-kernel-binary.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-powerpc-optimization-update.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-i386-optimization-update.patch
markers-add-instrumentation-markers-menus-to-avr32.patch
linux-kernel-markers-non-optimized-architectures.patch
markers-alpha-and-avr32-supportadd-alpha-markerh-add-arm26-markerh.patch
linux-kernel-markers-documentation.patch
markers-define-the-linker-macro-extra_rwdata.patch
markers-use-extra_rwdata-in-architectures.patch
