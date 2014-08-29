From: akpm@linux-foundation.org
Subject: + mn10300-use-kbuild-logic-to-include-asm-generic-sectionsh.patch added to -mm tree
Date: Fri, 29 Aug 2014 12:59:38 -0700
Message-ID: <5400dbaa.EWWz4+3ERAA+uwOa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45982 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbaH2T7j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Aug 2014 15:59:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mn10300: use Kbuild logic to include <asm-generic/sections.h>
has been added to the -mm tree.  Its filename is
     mn10300-use-kbuild-logic-to-include-asm-generic-sectionsh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mn10300-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mn10300-use-kbuild-logic-to-include-asm-generic-sectionsh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: mn10300: use Kbuild logic to include <asm-generic/sections.h>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/include/asm/Kbuild     |    1 +
 arch/mn10300/include/asm/sections.h |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/mn10300/include/asm/Kbuild~mn10300-use-kbuild-logic-to-include-asm-generic-sectionsh arch/mn10300/include/asm/Kbuild
--- a/arch/mn10300/include/asm/Kbuild~mn10300-use-kbuild-logic-to-include-asm-generic-sectionsh
+++ a/arch/mn10300/include/asm/Kbuild
@@ -7,4 +7,5 @@ generic-y += hash.h
 generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += scatterlist.h
+generic-y += sections.h
 generic-y += trace_clock.h
diff -puN arch/mn10300/include/asm/sections.h~mn10300-use-kbuild-logic-to-include-asm-generic-sectionsh /dev/null
--- a/arch/mn10300/include/asm/sections.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/sections.h>
_

Patches currently in -mm which might be from geert@linux-m68k.org are

checkpatch-relax-check-for-length-of-git-commit-ids.patch
flush_icache_range-export-symbol-to-fix-build-errors.patch
checkpatch-allow-commit-descriptions-on-separate-line-from-commit-id.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush-v2.patch
printk-dont-bother-using-log_cpu_max_buf_shift-on-smp.patch
linux-next.patch
alpha-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
cris-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
m32r-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
mn10300-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
score-use-kbuild-logic-to-include-asm-generic-sectionsh.patch

