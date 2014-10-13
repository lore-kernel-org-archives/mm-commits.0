From: akpm@linux-foundation.org
Subject: [merged]
 mn10300-use-kbuild-logic-to-include-asm-generic-sectionsh.patch removed
 from -mm tree
Date: Mon, 13 Oct 2014 11:17:09 -0700
Message-ID: <543c1725.4Ec4/ak7iyCPjHPk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59910 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbaJMSRK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:17:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mn10300: use Kbuild logic to include <asm-generic/sections.h>
has been removed from the -mm tree.  Its filename was
     mn10300-use-kbuild-logic-to-include-asm-generic-sectionsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -8,4 +8,5 @@ generic-y += irq_work.h
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

origin.patch
printk-dont-bother-using-log_cpu_max_buf_shift-on-smp.patch
printk-git-rid-of-message-for-printk_deferred.patch
linux-next.patch
frv-remove-unused-declarations-of-__start___ex_table-and-__stop___ex_table.patch
ia64-remove-duplicate-declarations-of-__per_cpu_start-and-__per_cpu_end.patch
kernel-param-consolidate-__startstop___param-in-linux-moduleparamh.patch

