From: akpm@linux-foundation.org
Subject: - alpha-notify_cpu_starting-compile-fixlet.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:10:48 -0700
Message-ID: <200810182310.m9INAmmh027610@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751111AbYJRXK4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:10:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: notify_cpu_starting() compile fixlet
has been removed from the -mm tree.  Its filename was
     alpha-notify_cpu_starting-compile-fixlet.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: notify_cpu_starting() compile fixlet
From: Alexey Dobriyan <adobriyan@gmail.com>

arch/alpha/kernel/smp.c:153: error: implicit declaration of function 'notify_cpu_starting'

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/smp.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/alpha/kernel/smp.c~alpha-notify_cpu_starting-compile-fixlet arch/alpha/kernel/smp.c
--- a/arch/alpha/kernel/smp.c~alpha-notify_cpu_starting-compile-fixlet
+++ a/arch/alpha/kernel/smp.c
@@ -27,6 +27,7 @@
 #include <linux/cache.h>
 #include <linux/profile.h>
 #include <linux/bitops.h>
+#include <linux/cpu.h>
 
 #include <asm/hwrpb.h>
 #include <asm/ptrace.h>
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
seq_file-dont-call-bitmap_scnprintf_len.patch
seq_file-add-seq_cpumask_list-seq_nodemask_list.patch
cpuset-use-seq_mask_-to-print-masks.patch
bitmask-remove-bitmap_scnprintf_len.patch
fs-kconfig-move-ext2-ext3-ext4-jbd-jbd2-out.patch
fs-kconfig-move-cifs-out.patch

