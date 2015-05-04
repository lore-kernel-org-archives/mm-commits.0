From: akpm@linux-foundation.org
Subject: +
 coredump-add-__printf-attribute-to-cn_printf-functions-checkpatch-fixes.patch added to -mm tree
Date: Mon, 04 May 2015 15:41:51 -0700
Message-ID: <5547f5af.pSyqZHEH3cZOJy4L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbbEDWlw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2015 18:41:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, nicolas.iooss_linux@m4x.org, mm-commits@vger.kernel.org


The patch titled
     Subject: coredump-add-__printf-attribute-to-cn_printf-functions-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     coredump-add-__printf-attribute-to-cn_printf-functions-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/coredump-add-__printf-attribute-to-cn_printf-functions-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/coredump-add-__printf-attribute-to-cn_printf-functions-checkpatch-fixes.patch

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
Subject: coredump-add-__printf-attribute-to-cn_printf-functions-checkpatch-fixes

WARNING: line over 80 characters
#59: FILE: fs/coredump.c:230:
+				err = cn_printf(cn, "%d", cprm->siginfo->si_signo);

total: 0 errors, 1 warnings, 34 lines checked

./patches/coredump-add-__printf-attribute-to-cn_printf-functions.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/coredump.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/coredump.c~coredump-add-__printf-attribute-to-cn_printf-functions-checkpatch-fixes fs/coredump.c
--- a/fs/coredump.c~coredump-add-__printf-attribute-to-cn_printf-functions-checkpatch-fixes
+++ a/fs/coredump.c
@@ -227,7 +227,8 @@ static int format_corename(struct core_n
 				break;
 			/* signal that caused the coredump */
 			case 's':
-				err = cn_printf(cn, "%d", cprm->siginfo->si_signo);
+				err = cn_printf(cn, "%d",
+						cprm->siginfo->si_signo);
 				break;
 			/* UNIX time of coredump */
 			case 't': {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
revert-zram-move-compact_store-to-sysfs-functions-area.patch
maintainers-add-co-maintainer-for-led-subsystem.patch
revert-fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-inline-some-helper-functions-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
coredump-add-__printf-attribute-to-cn_printf-functions-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

