From: akpm@linux-foundation.org
Subject: [merged]
 m32r-use-kbuild-logic-to-include-asm-generic-sectionsh.patch removed from
 -mm tree
Date: Mon, 13 Oct 2014 11:17:19 -0700
Message-ID: <543c172f.5B1T5hFAVWFbZ3dy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59933 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbaJMSRT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:17:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, takata@linux-m32r.org, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r: use Kbuild logic to include <asm-generic/sections.h>
has been removed from the -mm tree.  Its filename was
     m32r-use-kbuild-logic-to-include-asm-generic-sectionsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -8,4 +8,5 @@ generic-y += mcs_spinlock.h
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
