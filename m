From: akpm@linux-foundation.org
Subject: +
 init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes.patch added to -mm tree
Date: Mon, 20 Oct 2014 14:29:54 -0700
Message-ID: <54457ed2.4KuvSkHDsOhQWxVH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57068 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaJTV3y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Oct 2014 17:29:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cebbert.lkml@gmail.com, frowand.list@gmail.com, josh@joshtriplett.org, luto@amacapital.net, rdunlap@infradead.org, rob@landley.net, rusty@rustcorp.com.au, shuah.kh@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes.patch

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
Subject: init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes

WARNING: 'indended' may be misspelled - perhaps 'intended'?
#53: FILE: init/Kconfig:1315:
+	  especially on kiosks and on kernels that are indended to be

total: 0 errors, 1 warnings, 36 lines checked

./patches/init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: Frank Rowand <frowand.list@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Rob Landley <rob@landley.net>
Cc: Shuah Khan <shuah.kh@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/Kconfig~init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes init/Kconfig
--- a/init/Kconfig~init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes
+++ a/init/Kconfig
@@ -1312,7 +1312,7 @@ config INIT_FALLBACK
 
 	  The default value of Y is consistent with historical behavior.
 	  Selecting N is likely to be more appropriate for most uses,
-	  especially on kiosks and on kernels that are indended to be
+	  especially on kiosks and on kernels that are intended to be
 	  run under the control of a script.
 
 config CC_OPTIMIZE_FOR_SIZE
diff -puN init/main.c~init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes init/main.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-fix.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io-fix.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes-checkpatch-fixes.patch
mm.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-compaction-simplify-deferred-compaction-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes.patch

