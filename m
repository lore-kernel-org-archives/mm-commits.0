From: akpm@linux-foundation.org
Subject: - x86-minor-cleanup-of-comments-in-processorh.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:23:45 -0800
Message-ID: <200802232023.m1NKNjW6013569@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44550 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761829AbYBWU24 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:28:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: travis@sgi.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: minor cleanup of comments in processor.h
has been removed from the -mm tree.  Its filename was
     x86-minor-cleanup-of-comments-in-processorh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: minor cleanup of comments in processor.h
From: Mike Travis <travis@sgi.com>

Removal of trivial comments in processor.h

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/processor.h |    4 ----
 1 file changed, 4 deletions(-)

diff -puN include/asm-x86/processor.h~x86-minor-cleanup-of-comments-in-processorh include/asm-x86/processor.h
--- a/include/asm-x86/processor.h~x86-minor-cleanup-of-comments-in-processorh
+++ a/include/asm-x86/processor.h
@@ -302,10 +302,6 @@ union i387_union {
 };
 
 #ifdef CONFIG_X86_32
-/*
- * the following now lives in the per cpu area:
- * extern	int cpu_llc_id[NR_CPUS];
- */
 DECLARE_PER_CPU(u8, cpu_llc_id);
 #else
 DECLARE_PER_CPU(struct orig_ist, orig_ist);
_

Patches currently in -mm which might be from travis@sgi.com are

origin.patch
cpufreq-change-cpu-freq-tables-to-per_cpu-variables.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
init-move-setup-of-nr_cpu_ids-to-as-early-as-possible-v3.patch
generic-percpu-infrastructure-to-rebase-the-per-cpu-area-to-zero-v3.patch
x86_64-fold-pda-into-per-cpu-area-v3.patch
x86_64-cleanup-non-smp-usage-of-cpu-maps-v3.patch
