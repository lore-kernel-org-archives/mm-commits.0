From: akpm@linux-foundation.org
Subject: +
 add-another-clock-for-use-with-the-soft-lockup-watchdog-fix.patch added to
 -mm tree
Date: Mon, 05 Jan 2015 14:10:25 -0800
Message-ID: <54ab0bd1.DKn3RMATGXyKLtOa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58381 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbbAEWK1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2015 17:10:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, atomlin@redhat.com, benh@kernel.crashing.org, benzh@chromium.org, chaiw.fnst@cn.fujitsu.com, cyrilbur@gmail.com, drjones@redhat.com, dzickus@redhat.com, fabf@skynet.be, mingo@kernel.org, mpe@ellerman.id.au, tglx@linutronix.de, uobergfe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: add-another-clock-for-use-with-the-soft-lockup-watchdog-fix
has been added to the -mm tree.  Its filename is
     add-another-clock-for-use-with-the-soft-lockup-watchdog-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/add-another-clock-for-use-with-the-soft-lockup-watchdog-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/add-another-clock-for-use-with-the-soft-lockup-watchdog-fix.patch

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
Subject: add-another-clock-for-use-with-the-soft-lockup-watchdog-fix

remove EXPORT_SYMBOL(running_clock)

Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Andrew Jones <drjones@redhat.com>
Cc: Ben Zhang <benzh@chromium.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Cyril Bur <cyrilbur@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Cc: chai wen <chaiw.fnst@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/clock.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/sched/clock.c~add-another-clock-for-use-with-the-soft-lockup-watchdog-fix kernel/sched/clock.c
--- a/kernel/sched/clock.c~add-another-clock-for-use-with-the-soft-lockup-watchdog-fix
+++ a/kernel/sched/clock.c
@@ -86,7 +86,6 @@ unsigned long long __weak running_clock(
 {
 	return sched_clock();
 }
-EXPORT_SYMBOL_GPL(running_clock);
 
 __read_mostly int sched_clock_running;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-prevent-endless-growth-of-anon_vma-hierarchy-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
add-another-clock-for-use-with-the-soft-lockup-watchdog-fix.patch
mm.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
cma-fix-cmas-page-number-is-substructed-twice-in-__zone_watermark_ok-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
hexdump-makes-it-return-amount-of-bytes-placed-in-buffer-fix.patch
fs-befs-linuxvfsc-remove-unnecessary-casting-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

