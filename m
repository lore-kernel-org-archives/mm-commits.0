From: akpm@linux-foundation.org
Subject: + m32r-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
 added to -mm tree
Date: Fri, 29 Aug 2014 12:59:37 -0700
Message-ID: <5400dba9.zpCxpLTGezWyamMa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45978 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbaH2T7i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Aug 2014 15:59:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r: use Kbuild logic to include <asm-generic/sections.h>
has been added to the -mm tree.  Its filename is
     m32r-use-kbuild-logic-to-include-asm-generic-sectionsh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/m32r-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/m32r-use-kbuild-logic-to-include-asm-generic-sectionsh.patch

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
Subject: m32r: use Kbuild logic to include <asm-generic/sections.h>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/include/asm/Kbuild     |    1 +
 arch/m32r/include/asm/sections.h |    7 -------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff -puN arch/m32r/include/asm/Kbuild~m32r-use-kbuild-logic-to-include-asm-generic-sectionsh arch/m32r/include/asm/Kbuild
--- a/arch/m32r/include/asm/Kbuild~m32r-use-kbuild-logic-to-include-asm-generic-sectionsh
+++ a/arch/m32r/include/asm/Kbuild
@@ -7,4 +7,5 @@ generic-y += mcs_spinlock.h
 generic-y += module.h
 generic-y += preempt.h
 generic-y += scatterlist.h
+generic-y += sections.h
 generic-y += trace_clock.h
diff -puN arch/m32r/include/asm/sections.h~m32r-use-kbuild-logic-to-include-asm-generic-sectionsh /dev/null
--- a/arch/m32r/include/asm/sections.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _M32R_SECTIONS_H
-#define _M32R_SECTIONS_H
-
-/* nothing to see, move along */
-#include <asm-generic/sections.h>
