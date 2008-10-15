From: akpm@linux-foundation.org
Subject: + alpha-notify_cpu_starting-compile-fixlet.patch added to -mm tree
Date: Wed, 15 Oct 2008 15:12:46 -0700
Message-ID: <200810152212.m9FMCkbb012299@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753672AbYJOWMy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 18:12:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     alpha: notify_cpu_starting() compile fixlet
has been added to the -mm tree.  Its filename is
     alpha-notify_cpu_starting-compile-fixlet.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

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
tags-skip-in-filenames.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
alpha-notify_cpu_starting-compile-fixlet.patch
cpuset-use-seq_cpumask-seq_nodemask.patch
compat_binfmt_elf-definition-tweak.patch
proc-move-sysrq-trigger-out-of-fs-proc.patch
sysctl-simplify-strategy.patch
fs-kconfig-move-ext2-ext3-ext4-jbd-jbd2-out.patch
fs-kconfig-move-cifs-out.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

