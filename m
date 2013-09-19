From: akpm@linux-foundation.org
Subject: [folded-merged] fat-additions-to-support-fat_fallocate-fix.patch
 removed from -mm tree
Date: Thu, 19 Sep 2013 16:22:26 -0700
Message-ID: <523b8732.zrAnwMEUTPPYCnVJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58627 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab3ISXW1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Sep 2013 19:22:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ravi.n1@samsung.com, namjae.jeon@samsung.com, hirofumi@mail.parknet.co.jp, fengguang.wu@intel.com, a.sahrawat@samsung.com, akpm@linux-foundation.org

Subject: [folded-merged] fat-additions-to-support-fat_fallocate-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,a.sahrawat@samsung.com,fengguang.wu@intel.com,hirofumi@mail.parknet.co.jp,namjae.jeon@samsung.com,ravi.n1@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 19 Sep 2013 16:22:26 -0700


The patch titled
     Subject: fat-additions-to-support-fat_fallocate-fix
has been removed from the -mm tree.  Its filename was
     fat-additions-to-support-fat_fallocate-fix.patch

This patch was dropped because it was folded into fat-additions-to-support-fat_fallocate.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fat-additions-to-support-fat_fallocate-fix

fix min() warning

Cc: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: Namjae Jeon <namjae.jeon@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Ravishankar N <ravi.n1@samsung.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/fat/inode.c~fat-additions-to-support-fat_fallocate-fix fs/fat/inode.c
--- a/fs/fat/inode.c~fat-additions-to-support-fat_fallocate-fix
+++ a/fs/fat/inode.c
@@ -162,7 +162,8 @@ static int fat_zero_falloc_area(struct f
 	int err;
 
 	do {
-		unsigned offset, bytes;
+		unsigned offset;
+		size_t bytes;
 		void *fsdata;
 
 		offset = (curpos & (PAGE_CACHE_SIZE - 1));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
watchdog-update-watchdog_tresh-properly-fix.patch
revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
revert-memcg-track-all-children-over-limit-in-the-root.patch
revert-memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
revert-memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
revert-memcg-enhance-memcg-iterator-to-support-predicates.patch
revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
revert-memcg-get-rid-of-soft-limit-tree-infrastructure.patch
revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
mm-vmalloc-revert-mm-vmallocc-emit-the-failure-message-before-return-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

