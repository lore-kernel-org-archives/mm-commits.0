From: akpm@linux-foundation.org
Subject: + include-asm-generic-vtimeh-avoid-zero-length-file.patch added
 to -mm tree
Date: Wed, 25 Sep 2013 14:43:32 -0700
Message-ID: <52435904.MRaqgbkUU9760NVE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab3IYVnd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 17:43:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hughd@google.com, fweisbec@gmail.com, akpm@linux-foundation.org

Subject: + include-asm-generic-vtimeh-avoid-zero-length-file.patch added to -mm tree
To: akpm@linux-foundation.org,fweisbec@gmail.com,hughd@google.com
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 14:43:32 -0700


The patch titled
     Subject: include/asm-generic/vtime.h: avoid zero-length file
has been added to the -mm tree.  Its filename is
     include-asm-generic-vtimeh-avoid-zero-length-file.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-asm-generic-vtimeh-avoid-zero-length-file.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-asm-generic-vtimeh-avoid-zero-length-file.patch

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
Subject: include/asm-generic/vtime.h: avoid zero-length file

patch(1) can't handle zero-length files - it appears to simply not create
the file, so my powerpc build fails.

Put something in here to make life easier.

Cc: Hugh Dickins <hughd@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/vtime.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN /dev/null include/asm-generic/vtime.h
--- /dev/null
+++ a/include/asm-generic/vtime.h
@@ -0,0 +1 @@
+/* no content, but patch(1) dislikes empty files */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix-fix.patch
include-asm-generic-vtimeh-avoid-zero-length-file.patch
sound-soc-atmel-atmel-pcmc-fix-warning.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
kernel-printk-printkc-convert-to-pr_foo.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
linux-next-git-rejects.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

