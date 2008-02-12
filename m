From: akpm@linux-foundation.org
Subject: + x86-minor-cleanup-of-comments-in-processorh.patch added to -mm tree
Date: Tue, 12 Feb 2008 15:35:09 -0800
Message-ID: <200802122335.m1CNZ90e028800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59268 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755805AbYBLXfc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 18:35:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: minor cleanup of comments in processor.h
has been added to the -mm tree.  Its filename is
     x86-minor-cleanup-of-comments-in-processorh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
x86-minor-cleanup-of-comments-in-processorh.patch
