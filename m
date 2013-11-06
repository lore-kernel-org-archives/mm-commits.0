From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix-fix.patch removed from -mm tree
Date: Wed, 06 Nov 2013 13:36:02 -0800
Message-ID: <527ab642.d6i5Qj+LREjUEdO7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39498 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab3KFVgC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Nov 2013 16:36:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,kirill.shutemov@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 06 Nov 2013 13:36:02 -0800


The patch titled
     Subject: mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix-fix.patch

This patch was dropped because it was folded into mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix-fix

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/split_page_table_lock |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/vm/split_page_table_lock~mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix-fix Documentation/vm/split_page_table_lock
--- a/Documentation/vm/split_page_table_lock~mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix-fix
+++ a/Documentation/vm/split_page_table_lock
@@ -54,7 +54,7 @@ everything required is done by pgtable_p
 which must be called on PTE table allocation / freeing.
 
 Make sure the architecture doesn't use slab allocator for page table
-allacation: slab uses page->slab_cache and page->first_page for its pages.
+allocation: slab uses page->slab_cache and page->first_page for its pages.
 These fields share storage with page->ptl.
 
 PMD split lock only makes sense if you have more than two page table
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
posix_acl-uninlining.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
mm-factor-commit-limit-calculation-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
drivers-rtc-rtc-as3722-add-rtc-driver-checkpatch-fixes.patch
fs-hfs-btreeh-remove-duplicate-defines-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
ipc-msg-fix-message-length-check-for-negative-values-fix.patch
linux-next.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up-next-fix.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page.patch
tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch
kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix.patch
llists-move-llist_reverse_order-from-raid5-to-llistc-fix.patch
kfifo-api-type-safety-checkpatch-fixes.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

