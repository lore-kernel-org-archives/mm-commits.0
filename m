From: akpm@linux-foundation.org
Subject: [folded-merged]
 treewide-decouple-cacheflushh-and-set_memoryh-fix.patch removed from -mm
 tree
Date: Mon, 08 May 2017 15:40:39 -0700
Message-ID: <5910f3e7.GCLZDsdByclWnydQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42606 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751094AbdEHWkk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:40:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kprobes/x86: merge fix for set_memory.h decoupling
has been removed from the -mm tree.  Its filename was
     treewide-decouple-cacheflushh-and-set_memoryh-fix.patch

This patch was dropped because it was folded into treewide-decouple-cacheflushh-and-set_memoryh.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: kprobes/x86: merge fix for set_memory.h decoupling

Link: http://lkml.kernel.org/r/20170418180903.10300fd3@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/kprobes/core.c |    1 +
 arch/x86/kernel/kprobes/opt.c  |    1 +
 2 files changed, 2 insertions(+)

diff -puN arch/x86/kernel/kprobes/core.c~treewide-decouple-cacheflushh-and-set_memoryh-fix arch/x86/kernel/kprobes/core.c
--- a/arch/x86/kernel/kprobes/core.c~treewide-decouple-cacheflushh-and-set_memoryh-fix
+++ a/arch/x86/kernel/kprobes/core.c
@@ -61,6 +61,7 @@
 #include <asm/alternative.h>
 #include <asm/insn.h>
 #include <asm/debugreg.h>
+#include <asm/set_memory.h>
 
 #include "common.h"
 
diff -puN arch/x86/kernel/kprobes/opt.c~treewide-decouple-cacheflushh-and-set_memoryh-fix arch/x86/kernel/kprobes/opt.c
--- a/arch/x86/kernel/kprobes/opt.c~treewide-decouple-cacheflushh-and-set_memoryh-fix
+++ a/arch/x86/kernel/kprobes/opt.c
@@ -37,6 +37,7 @@
 #include <asm/alternative.h>
 #include <asm/insn.h>
 #include <asm/debugreg.h>
+#include <asm/set_memory.h>
 
 #include "common.h"
 
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-introduce-kvalloc-helpers-fix.patch
treewide-decouple-cacheflushh-and-set_memoryh.patch
gfs2-replace-current_time-with-current_time.patch

