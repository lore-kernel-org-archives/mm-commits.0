From: akpm@linux-foundation.org
Subject: + mm-memcontrol-lockless-page-counters-fix-fix.patch added to -mm tree
Date: Tue, 14 Oct 2014 14:03:12 -0700
Message-ID: <543d8f90.mC/MhoJws/PeQ+Eh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaJNVDM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 17:03:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: [patch] mm-memcontrol-lockless-page-counters-fix
has been added to the -mm tree.  Its filename is
     mm-memcontrol-lockless-page-counters-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-lockless-page-counters-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-lockless-page-counters-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] mm-memcontrol-lockless-page-counters-fix

add includes for WARN_ON_ONCE, memparse, strncmp, and PAGE_SIZE

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_counter.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/page_counter.c~mm-memcontrol-lockless-page-counters-fix-fix mm/page_counter.c
--- a/mm/page_counter.c~mm-memcontrol-lockless-page-counters-fix-fix
+++ a/mm/page_counter.c
@@ -4,11 +4,13 @@
  * Copyright (C) 2014 Red Hat, Inc., Johannes Weiner
  */
 
-#include <linux/kernel.h>
-#include <linux/bug.h>
 #include <linux/page_counter.h>
 #include <linux/atomic.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
 #include <linux/sched.h>
+#include <linux/bug.h>
+#include <asm/page.h>
 
 /**
  * page_counter_cancel - take pages out of the local counter
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans-fix.patch
mm.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

