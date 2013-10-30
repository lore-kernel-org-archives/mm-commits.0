From: akpm@linux-foundation.org
Subject: [failures]
 mm-add-a-field-to-store-names-for-private-anonymous-memory-fix-fix-2.patch
 removed from -mm tree
Date: Wed, 30 Oct 2013 13:50:51 -0700
Message-ID: <5271712b.KPfpHfiLICKExAGA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab3J3Uuv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Oct 2013 16:50:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ccross@android.com, akpm@linux-foundation.org

Subject: [failures] mm-add-a-field-to-store-names-for-private-anonymous-memory-fix-fix-2.patch removed from -mm tree
To: akpm@linux-foundation.org,ccross@android.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 30 Oct 2013 13:50:51 -0700


The patch titled
     Subject: mm-add-a-field-to-store-names-for-private-anonymous-memory-fix-fix-2
has been removed from the -mm tree.  Its filename was
     mm-add-a-field-to-store-names-for-private-anonymous-memory-fix-fix-2.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-a-field-to-store-names-for-private-anonymous-memory-fix-fix-2

remove unused local

Cc: Colin Cross <ccross@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/proc/task_mmu.c~mm-add-a-field-to-store-names-for-private-anonymous-memory-fix-fix-2 fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-add-a-field-to-store-names-for-private-anonymous-memory-fix-fix-2
+++ a/fs/proc/task_mmu.c
@@ -95,7 +95,6 @@ static void seq_print_vma_name(struct se
 {
 	struct mm_struct *mm = vma->vm_mm;
 	char anon_name[NAME_MAX + 1];
-	unsigned long addr;
 	int n;
 
 	n = access_remote_vm(mm, (unsigned long)vma_anon_name(vma),
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
posix_acl-uninlining.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
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
net-netfilter-ipset-ip_set_hash_netnetc-fix-build-with-older-gcc.patch
net-netfilter-ipset-ip_set_hash_netportnetc-fix-build-with-older-gccs.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix-fix.patch
seq_file-remove-%n-usage-from-seq_file-users-fix.patch
tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

