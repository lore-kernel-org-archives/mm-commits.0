From: akpm@linux-foundation.org
Subject: [merged]
 score-use-kbuild-logic-to-include-asm-generic-sectionsh.patch removed from
 -mm tree
Date: Mon, 13 Oct 2014 11:17:27 -0700
Message-ID: <543c1737.0b5bQ3D0ohJ3soov%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59945 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbaJMSR1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:17:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, lennox.wu@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: score: use Kbuild logic to include <asm-generic/sections.h>
has been removed from the -mm tree.  Its filename was
     score-use-kbuild-logic-to-include-asm-generic-sectionsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: score: use Kbuild logic to include <asm-generic/sections.h>

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/score/include/asm/Kbuild     |    1 +
 arch/score/include/asm/sections.h |    6 ------
 2 files changed, 1 insertion(+), 6 deletions(-)

diff -puN arch/score/include/asm/Kbuild~score-use-kbuild-logic-to-include-asm-generic-sectionsh arch/score/include/asm/Kbuild
--- a/arch/score/include/asm/Kbuild~score-use-kbuild-logic-to-include-asm-generic-sectionsh
+++ a/arch/score/include/asm/Kbuild
@@ -10,6 +10,7 @@ generic-y += irq_work.h
 generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += scatterlist.h
+generic-y += sections.h
 generic-y += trace_clock.h
 generic-y += xor.h
 generic-y += serial.h
diff -puN arch/score/include/asm/sections.h~score-use-kbuild-logic-to-include-asm-generic-sectionsh /dev/null
--- a/arch/score/include/asm/sections.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_SCORE_SECTIONS_H
-#define _ASM_SCORE_SECTIONS_H
-
-#include <asm-generic/sections.h>
