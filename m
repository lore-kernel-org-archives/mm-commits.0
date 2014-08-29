From: akpm@linux-foundation.org
Subject: + cris-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
 added to -mm tree
Date: Fri, 29 Aug 2014 12:59:36 -0700
Message-ID: <5400dba8.b8GHwhcKfnfIdSuX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45975 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbaH2T7h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Aug 2014 15:59:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, jesper.nilsson@axis.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cris: use Kbuild logic to include <asm-generic/sections.h>
has been added to the -mm tree.  Its filename is
     cris-use-kbuild-logic-to-include-asm-generic-sectionsh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cris-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cris-use-kbuild-logic-to-include-asm-generic-sectionsh.patch

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
Subject: cris: use Kbuild logic to include <asm-generic/sections.h>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/include/asm/Kbuild     |    1 +
 arch/cris/include/asm/sections.h |    7 -------
 2 files changed, 1 insertion(+), 7 deletions(-)

diff -puN arch/cris/include/asm/Kbuild~cris-use-kbuild-logic-to-include-asm-generic-sectionsh arch/cris/include/asm/Kbuild
--- a/arch/cris/include/asm/Kbuild~cris-use-kbuild-logic-to-include-asm-generic-sectionsh
+++ a/arch/cris/include/asm/Kbuild
@@ -14,6 +14,7 @@ generic-y += mcs_spinlock.h
 generic-y += module.h
 generic-y += preempt.h
 generic-y += scatterlist.h
+generic-y += sections.h
 generic-y += trace_clock.h
 generic-y += vga.h
 generic-y += xor.h
diff -puN arch/cris/include/asm/sections.h~cris-use-kbuild-logic-to-include-asm-generic-sectionsh /dev/null
--- a/arch/cris/include/asm/sections.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef _CRIS_SECTIONS_H
-#define _CRIS_SECTIONS_H
-
-/* nothing to see, move along */
-#include <asm-generic/sections.h>
