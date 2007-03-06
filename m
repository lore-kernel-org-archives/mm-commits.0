From: akpm@linux-foundation.org
Subject: - local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix-2.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:31:56 -0800
Message-ID: <200703060131.l261Vv8J007785@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45457 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933781AbXCFBcK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:32:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     fix wrong definition of LOCAL_INIT in mips
has been removed from the -mm tree.  Its filename was
     local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix-2.patch

This patch was dropped because it was folded into local_t-mips-extension.patch

------------------------------------------------------
Subject: fix wrong definition of LOCAL_INIT in mips
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

fix wrong definition of LOCAL_INIT in mips

Applies on top of
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mips/local.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-mips/local.h~local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix-2 include/asm-mips/local.h
--- a/include/asm-mips/local.h~local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix-2
+++ a/include/asm-mips/local.h
@@ -11,7 +11,7 @@ typedef struct
 	atomic_long_t a;
 } local_t;
 
-#define LOCAL_INIT(i)	{ local_LONG_INIT(i) }
+#define LOCAL_INIT(i)	{ ATOMIC_LONG_INIT(i) }
 
 #define local_read(l)	atomic_long_read(&(l)->a)
 #define local_set(l,i)	atomic_long_set(&(l)->a, (i))
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
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix-2.patch
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
local_t-powerpc-extension-fix.patch
local_t-powerpc-extension-shrink-powerpc-localh.patch
local_t-powerpc-extension-fix-build-fix.patch
local_t-sparc64-cleanup.patch
local_t-x86_64-extension.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-kconfig-menus-fix.patch
linux-kernel-markers-kconfig-menus-fix-2.patch
linux-kernel-markers-kconfig-menus-fix-3.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
linux-kernel-markers-kconfig-menus-fix-5.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-architecture-independant-code-license-fix.patch
linux-kernel-markers-architecture-independant-code-flags.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-powerpc-optimization-flags.patch
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
