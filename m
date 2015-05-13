From: akpm@linux-foundation.org
Subject: + make-drivers-misc-kgdbtsc-link.patch added to -mm tree
Date: Wed, 13 May 2015 15:56:37 -0700
Message-ID: <5553d6a5.HYsHr6JWKOJQpyKA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57100 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934426AbbEMW4i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 May 2015 18:56:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, josh@joshtriplett.org, mm-commits@vger.kernel.org


The patch titled
     Subject: make drivers/misc/kgdbts.c link
has been added to the -mm tree.  Its filename is
     make-drivers-misc-kgdbtsc-link.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/make-drivers-misc-kgdbtsc-link.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/make-drivers-misc-kgdbtsc-link.patch

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
Subject: make drivers/misc/kgdbts.c link

Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/fork.c~make-drivers-misc-kgdbtsc-link kernel/fork.c
--- a/kernel/fork.c~make-drivers-misc-kgdbtsc-link
+++ a/kernel/fork.c
@@ -1744,7 +1744,6 @@ static long _do_fork(
 	return nr;
 }
 
-#ifndef CONFIG_HAVE_COPY_THREAD_TLS
 /* For compatibility with architectures that call do_fork directly rather than
  * using the syscall entry points below. */
 long do_fork(unsigned long clone_flags,
@@ -1756,7 +1755,6 @@ long do_fork(unsigned long clone_flags,
 	return _do_fork(clone_flags, stack_start, stack_size,
 			parent_tidptr, child_tidptr, 0);
 }
-#endif
 
 /*
  * Create a kernel thread.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-rtc-rtc-armada38xc-remove-unused-local-flags.patch
gfp-add-__gfp_noaccount-v2-fix.patch
cma-page_isolation-check-buddy-before-access-it-fix.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix.patch
mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix.patch
mm-clarify-that-the-function-operateds-on-hugepage-pte-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
proc-fix-page_size-limit-of-proc-pid-cmdline-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
radix-tree-replace-preallocated-node-array-with-linked-list-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
net-bridge-br_stpc-work-around-gcc-444-initializer-bug.patch
net-switchdev-switchdevc-work-around-gcc-444-initializer-bug.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
make-drivers-misc-kgdbtsc-link.patch

