From: akpm@linux-foundation.org
Subject: + linux-kernel-markers-kconfig-menus-fix-3.patch added to -mm tree
Date: Fri, 16 Feb 2007 13:57:11 -0800
Message-ID: <200702162157.l1GLvBFK010871@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37927 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946148AbXBPV5T (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 16:57:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca


The patch titled
     remove include of linux/marker.h from Makefile
has been added to the -mm tree.  Its filename is
     linux-kernel-markers-kconfig-menus-fix-3.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove include of linux/marker.h from Makefile
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

It is conventional and reasonable to require that any code which uses this
mechanism must include its header file.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

diff -puN Makefile~linux-kernel-markers-kconfig-menus-fix-3 Makefile
--- a/Makefile~linux-kernel-markers-kconfig-menus-fix-3
+++ a/Makefile
@@ -308,9 +308,7 @@ AFLAGS_KERNEL	=
 # Needed to be compatible with the O= option
 LINUXINCLUDE    := -Iinclude \
                    $(if $(KBUILD_SRC),-Iinclude2 -I$(srctree)/include) \
-		   -include include/linux/autoconf.h \
-		   -include \
-		   	$(if $(KBUILD_SRC),$(srctree)/)include/linux/marker.h
+		   -include include/linux/autoconf.h
 
 CPPFLAGS        := -D__KERNEL__ $(LINUXINCLUDE)
 
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
git-powerpc.patch
powerpc-move-of_irq_to_resource-to-prom_parsec.patch
git-mips.patch
git-s390.patch
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
local_t-mips-extension-fix.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh.patch
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
local_t-powerpc-extension-fix.patch
local_t-powerpc-extension-shrink-powerpc-localh.patch
local_t-sparc64-cleanup.patch
local_t-x86_64-extension.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-kconfig-menus-fix.patch
linux-kernel-markers-kconfig-menus-fix-2.patch
linux-kernel-markers-kconfig-menus-fix-3.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-fix.patch
linux-kernel-markers-documentation-update-adds-context.patch
linux-kernel-markers-documentation-update-markerh.patch
