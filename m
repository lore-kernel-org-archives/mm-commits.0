From: akpm@linux-foundation.org
Subject: [merged]
 cris-use-kbuild-logic-to-include-asm-generic-sectionsh.patch removed from
 -mm tree
Date: Mon, 13 Oct 2014 11:17:11 -0700
Message-ID: <543c1727.tyXKkXFBUrJH6yKP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59912 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbaJMSRL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:17:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, jesper.nilsson@axis.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cris: use Kbuild logic to include <asm-generic/sections.h>
has been removed from the -mm tree.  Its filename was
     cris-use-kbuild-logic-to-include-asm-generic-sectionsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -15,6 +15,7 @@ generic-y += mcs_spinlock.h
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
