From: akpm@linux-foundation.org
Subject: +
 lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
 added to -mm tree
Date: Fri, 19 Jul 2013 15:32:30 -0700
Message-ID: <51e9be7e.PeVmFdd0+zh+IBEV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52595 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab3GSWcb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Jul 2013 18:32:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, guz.fnst@cn.fujitsu.com, akpm@linux-foundation.org

Subject: + lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch added to -mm tree
To: akpm@linux-foundation.org,guz.fnst@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Fri, 19 Jul 2013 15:32:30 -0700


The patch titled
     Subject: lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch

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
Subject: lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes

Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>

WARNING: please, no space before tabs
#20: FILE: lib/crc32.c:135:
+ * ^I^I^ICRC32/CRC32C$

WARNING: line over 80 characters
#24: FILE: lib/crc32.c:137:
+ *	other uses, or the previous crc32/crc32c value if computing incrementally.

total: 0 errors, 2 warnings, 32 lines checked

./patches/lib-crc32-update-the-comments-of-crc32_bele_generic.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/crc32.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/crc32.c~lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes lib/crc32.c
--- a/lib/crc32.c~lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes
+++ a/lib/crc32.c
@@ -132,9 +132,9 @@ crc32_body(u32 crc, unsigned char const
 
 /**
  * crc32_le_generic() - Calculate bitwise little-endian Ethernet AUTODIN II
- * 			CRC32/CRC32C
- * @crc: seed value for computation.  ~0 for Ethernet, sometimes 0 for
- *	other uses, or the previous crc32/crc32c value if computing incrementally.
+ *			CRC32/CRC32C
+ * @crc: seed value for computation.  ~0 for Ethernet, sometimes 0 for other
+ *	 uses, or the previous crc32/crc32c value if computing incrementally.
  * @p: pointer to buffer over which CRC32/CRC32C is run
  * @len: length of buffer @p
  * @tab: little-endian Ethernet table
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix.patch
arch-x86-platform-ce4100-ce4100c-include-rebooth.patch
mm.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
mm-swapfilec-convert-to-pr_foo.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

