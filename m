From: akpm@linux-foundation.org
Subject: + ia64-fix-typo-in-per_cpu_offset.patch added to -mm tree
Date: Mon, 29 Oct 2007 14:03:05 -0700
Message-ID: <200710292103.l9TL35iN023137@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52857 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751935AbXJ2VDI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 17:03:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: luming.yu@gmail.com, luming.yu@intel.com, tony.luck@intel.com


The patch titled
     ia64: fix typo in per_cpu_offset
has been added to the -mm tree.  Its filename is
     ia64-fix-typo-in-per_cpu_offset.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
ia64-fix-typo-in-per_cpu_offset.patch
