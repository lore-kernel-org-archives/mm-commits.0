From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-documentation-fix-typo-and-use-array_size.patch removed from -mm tree
Date: Mon, 30 Apr 2007 13:28:12 -0700
Message-ID: <200704302028.l3UKSCrZ014204@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946788AbXD3U2V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 16:28:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     Linux Kernel Markers documentation fix typo and use ARRAY_SIZE
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-documentation-fix-typo-and-use-array_size.patch

This patch was dropped because it was folded into linux-kernel-markers-documentation.patch

------------------------------------------------------
Subject: Linux Kernel Markers documentation fix typo and use ARRAY_SIZE
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Linux Kernel Markers documentation fix typo and use ARRAY_SIZE

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/marker.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/marker.txt~linux-kernel-markers-documentation-fix-typo-and-use-array_size Documentation/marker.txt
--- a/Documentation/marker.txt~linux-kernel-markers-documentation-fix-typo-and-use-array_size
+++ a/Documentation/marker.txt
@@ -103,7 +103,7 @@ clean:
 ------------------------------ CUT -------------------------------------
 /* probe-example.c
  *
- * Connects a two functions to marker call sites.
+ * Connects two functions to marker call sites.
  *
  * (C) Copyright 2007 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
  *
@@ -117,7 +117,7 @@ clean:
 #include <linux/marker.h>
 #include <asm/atomic.h>
 
-#define NUM_PROBES (sizeof(probe_array) / sizeof(struct probe_data))
+#define NUM_PROBES ARRAY_SIZE(probe_array)
 
 struct probe_data {
 	const char *name;
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
git-powerpc.patch
ppc4xx_sgdma-needs-dma_mappingh.patch
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
markers-add-instrumentation-markers-menus-to-avr32.patch
linux-kernel-markers-non-optimized-architectures.patch
markers-alpha-and-avr32-supportadd-alpha-markerh-add-arm26-markerh.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-fix-typo-and-use-array_size.patch
markers-define-the-linker-macro-extra_rwdata.patch
markers-use-extra_rwdata-in-architectures.patch
