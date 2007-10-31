From: akpm@linux-foundation.org
Subject: - ia64-fix-typo-in-per_cpu_offset.patch removed from -mm tree
Date: Wed, 31 Oct 2007 16:21:56 -0700
Message-ID: <200710312321.l9VNLuua001912@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48494 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752995AbXJaXW2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Oct 2007 19:22:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luming.yu@gmail.com, luming.yu@intel.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     ia64: fix typo in per_cpu_offset
has been removed from the -mm tree.  Its filename was
     ia64-fix-typo-in-per_cpu_offset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ia64: fix typo in per_cpu_offset
From: "Luming Yu" <luming.yu@gmail.com>

Signed-off-by: Yu Luming <luming.yu@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-ia64/percpu.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-ia64/percpu.h~ia64-fix-typo-in-per_cpu_offset include/asm-ia64/percpu.h
--- a/include/asm-ia64/percpu.h~ia64-fix-typo-in-per_cpu_offset
+++ a/include/asm-ia64/percpu.h
@@ -46,7 +46,7 @@
 #ifdef CONFIG_SMP
 
 extern unsigned long __per_cpu_offset[NR_CPUS];
-#define per_cpu_offset(x) (__per_cpu_offset(x))
+#define per_cpu_offset(x) (__per_cpu_offset[x])
 
 /* Equal to __per_cpu_offset[smp_processor_id()], but faster to access: */
 DECLARE_PER_CPU(unsigned long, local_per_cpu_offset);
_

Patches currently in -mm which might be from luming.yu@gmail.com are

serial-only-use-pnp-irq-if-its-valid.patch
