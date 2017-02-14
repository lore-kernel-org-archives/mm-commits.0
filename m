From: akpm@linux-foundation.org
Subject: +
 kprobes-move-kprobe-declarations-to-asm-generic-kprobesh-fix-2.patch added
 to -mm tree
Date: Tue, 14 Feb 2017 13:56:18 -0800
Message-ID: <58a37d02.Q0QwyyYdZf1twFjd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55446 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750711AbdBNV4T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2017 16:56:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, mcgrof@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/kprobes: fixup for kprobes declarations moving
has been added to the -mm tree.  Its filename is
     kprobes-move-kprobe-declarations-to-asm-generic-kprobesh-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kprobes-move-kprobe-declarations-to-asm-generic-kprobesh-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kprobes-move-kprobe-declarations-to-asm-generic-kprobesh-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kprobes-move-kprobe-declarations-to-asm-generic-kprobesh-fix-2.patch

