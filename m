From: akpm@linux-foundation.org
Subject: - arch-mips-remove-duplicate-includes.patch removed from -mm tree
Date: Fri, 09 Nov 2007 11:13:11 -0800
Message-ID: <200711091913.lA9JDBjm027989@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43950 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755201AbXKITNX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 14:13:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: woodzy@gmail.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     arch/mips: remove duplicate includes
has been removed from the -mm tree.  Its filename was
     arch-mips-remove-duplicate-includes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: arch/mips: remove duplicate includes
From: Lucas Woods <woodzy@gmail.com>

Signed-off-by: Lucas Woods <woodzy@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/rtlx.c |    1 -
 arch/mips/kernel/vpe.c  |    1 -
 2 files changed, 2 deletions(-)

diff -puN arch/mips/kernel/rtlx.c~arch-mips-remove-duplicate-includes arch/mips/kernel/rtlx.c
--- a/arch/mips/kernel/rtlx.c~arch-mips-remove-duplicate-includes
+++ a/arch/mips/kernel/rtlx.c
@@ -40,7 +40,6 @@
 #include <asm/atomic.h>
 #include <asm/cpu.h>
 #include <asm/processor.h>
-#include <asm/mips_mt.h>
 #include <asm/system.h>
 #include <asm/vpe.h>
 #include <asm/rtlx.h>
diff -puN arch/mips/kernel/vpe.c~arch-mips-remove-duplicate-includes arch/mips/kernel/vpe.c
--- a/arch/mips/kernel/vpe.c~arch-mips-remove-duplicate-includes
+++ a/arch/mips/kernel/vpe.c
@@ -53,7 +53,6 @@
 #include <asm/system.h>
 #include <asm/vpe.h>
 #include <asm/kspd.h>
-#include <asm/mips_mt.h>
 
 typedef void *vpe_handle;
 
_

Patches currently in -mm which might be from woodzy@gmail.com are

arch-arm-removed-duplicate-includes.patch
arch-powerpc-remove-duplicate-includes.patch
arch-ppc-remove-duplicate-includes.patch
git-ia64.patch
git-mips.patch
arch-parisc-remove-duplicate-includes.patch
git-sparc64.patch
arch-x86-remove-duplicate-includes.patch
arch-xtensa-remove-duplicate-includes.patch
arch-alpha-removed-duplicate-includes.patch
arch-um-remove-duplicate-includes.patch
