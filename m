From: akpm@linux-foundation.org
Subject: [folded-merged]
 kprobes-move-kprobe-declarations-to-asm-generic-kprobesh-fix-2.patch
 removed from -mm tree
Date: Mon, 27 Feb 2017 14:17:03 -0800
Message-ID: <58b4a55f.yBRlqfwPxA2XHHG+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44558 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751583AbdB0W0n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:26:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, mcgrof@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/kprobes: fixup for kprobes declarations moving
has been removed from the -mm tree.  Its filename was
     kprobes-move-kprobe-declarations-to-asm-generic-kprobesh-fix-2.patch

This patch was dropped because it was folded into kprobes-move-kprobe-declarations-to-asm-generic-kprobesh.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: powerpc/kprobes: fixup for kprobes declarations moving

Link: http://lkml.kernel.org/r/20170214165933.13ebd4f4@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/lib/code-patching.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/powerpc/lib/code-patching.c~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh-fix-2 arch/powerpc/lib/code-patching.c
--- a/arch/powerpc/lib/code-patching.c~kprobes-move-kprobe-declarations-to-asm-generic-kprobesh-fix-2
+++ a/arch/powerpc/lib/code-patching.c
@@ -14,6 +14,7 @@
 #include <asm/page.h>
 #include <asm/code-patching.h>
 #include <linux/uaccess.h>
+#include <linux/kprobes.h>
 
 
 int patch_instruction(unsigned int *addr, unsigned int instr)
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

kprobes-move-kprobe-declarations-to-asm-generic-kprobesh.patch

