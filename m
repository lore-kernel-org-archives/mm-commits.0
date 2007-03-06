From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-i386-optimization-fix.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:40:12 -0800
Message-ID: <200703060140.l261eDtM008055@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45823 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933799AbXCFBkW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:40:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     add missing include marker.h in arch/i386/kernel/marker.c
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-i386-optimization-fix.patch

This patch was dropped because it was folded into linux-kernel-markers-i386-optimization.patch

------------------------------------------------------
Subject: add missing include marker.h in arch/i386/kernel/marker.c
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

add missing include marker.h in arch/i386/kernel/marker.c

marker.c also needs to include marker.h now.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/marker.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN arch/i386/kernel/marker.c~linux-kernel-markers-i386-optimization-fix arch/i386/kernel/marker.c
--- a/arch/i386/kernel/marker.c~linux-kernel-markers-i386-optimization-fix
+++ a/arch/i386/kernel/marker.c
@@ -15,6 +15,7 @@
 #include <linux/smp.h>
 #include <linux/notifier.h>
 #include <linux/module.h>
+#include <linux/marker.h>
 #include <asm/cacheflush.h>
 #include <asm/kdebug.h>
 
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
atomich-complete-atomic_long-operations-in-asm-generic.patch
atomich-i386-type-safety-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-ia64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
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
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-i386-optimization-fix.patch
linux-kernel-markers-i386-optimization-export-fix.patch
linux-kernel-markers-i386-optimization-flags.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-non-optimized-architures-fallback-flags.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-fix.patch
linux-kernel-markers-documentation-update-adds-context.patch
linux-kernel-markers-documentation-update-markerh.patch
linux-kernel-markers-documentation-update-flags.patch
