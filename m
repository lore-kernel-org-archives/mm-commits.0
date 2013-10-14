From: akpm@linux-foundation.org
Subject: +
 mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently-checkpatch-fixes.patch added to -mm tree
Date: Mon, 14 Oct 2013 15:23:25 -0700
Message-ID: <525c6edd.pIcat3zCteY73DZV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab3JNWX0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Oct 2013 18:23:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, weijie.yang@samsung.com, akpm@linux-foundation.org

Subject: + mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently-checkpatch-fixes.patch added to -mm tree
To: akpm@linux-foundation.org,weijie.yang@samsung.com
From: akpm@linux-foundation.org
Date: Mon, 14 Oct 2013 15:23:25 -0700


The patch titled
     Subject: mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently-checkpatch-fixes.patch

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
Subject: mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently-checkpatch-fixes

WARNING: please, no space before tabs
#53: FILE: mm/zswap.c:406:
+ * ^Ipage is locked$

total: 0 errors, 1 warnings, 55 lines checked

./patches/mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Weijie Yang <weijie.yang@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/zswap.c~mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently-checkpatch-fixes mm/zswap.c
--- a/mm/zswap.c~mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently-checkpatch-fixes
+++ a/mm/zswap.c
@@ -403,7 +403,7 @@ enum zswap_get_swap_ret {
  * If success, the swap cache page is returned in retpage
  * Returns ZSWAP_SWAPCACHE_EXIST if page was already in the swap cache
  * Returns ZSWAP_SWAPCACHE_NEW if the new page needs to be populated,
- * 	page is locked
+ *	page is locked
  * Returns ZSWAP_SWAPCACHE_FAIL on error
  */
 static int zswap_get_swap_cache_page(swp_entry_t entry,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
ipc-update-locking-scheme-comments-fix.patch
mm-zswap-bugfix-memory-leak-when-invalidate-and-reclaim-occur-concurrently-checkpatch-fixes.patch
mm-hugetlb-initialize-pg_reserved-for-tail-pages-of-gigantig-compound-pages-fix.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
posix_acl-uninlining.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
linux-next-git-rejects.patch
linux-next-rejects.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up-next-fix.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

