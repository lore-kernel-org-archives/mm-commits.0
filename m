From: akpm@linux-foundation.org
Subject: + markers-add-instrumentation-markers-menus-to-avr32.patch added to -mm tree
Date: Tue, 10 Apr 2007 22:05:10 -0700
Message-ID: <200704110505.l3B55Ac4028941@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59234 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161194AbXDKFFV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 01:05:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, hskinnemoen@atmel.com


The patch titled
     markers: add instrumentation/markers menus to avr32.
has been added to the -mm tree.  Its filename is
     markers-add-instrumentation-markers-menus-to-avr32.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: markers: add instrumentation/markers menus to avr32.
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
@@ -16,4 +19,8 @@ config KPROBES
           for kernel debugging, non-intrusive instrumentation and testing.
           If in doubt, say "N".
 
+source "kernel/Kconfig.marker"
+
+endmenu
+
 endmenu
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

avr32-remove-unneeded-cast-in-atomich.patch
git-powerpc.patch
ppc4xx_sgdma-needs-dma_mappingh.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
atomich-complete-atomic_long-operations-in-asm-generic.patch
atomich-i386-type-safety-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-ia64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64.patch
atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency.patch
local_t-architecture-independant-extension.patch
local_t-alpha-extension.patch
local_t-i386-extension.patch
local_t-ia64-extension.patch
local_t-mips-extension.patch
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
local_t-sparc64-cleanup.patch
local_t-x86_64-extension.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-architecture-independant-code-markers-document-the-linux-markerh-header.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-powerpc-optimization-markers-changes-to-the-powerpc-marker-header.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-i386-optimization-fix.patch
linux-kernel-markers-i386-optimization-markers-document-the-i386-marker-header.patch
markers-add-instrumentation-markers-menus-to-avr32.patch
linux-kernel-markers-non-optimized-architectures.patch
markers-alpha-and-avr32-supportadd-alpha-markerh-add-arm26-markerh.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-markers-update-documentation.patch
markers-define-the-linker-macro-extra_rwdata.patch
markers-use-extra_rwdata-in-architectures.patch
markers-add-documentation-to-the-modulec-marker-functions.patch
