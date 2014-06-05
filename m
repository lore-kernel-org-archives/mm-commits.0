From: akpm@linux-foundation.org
Subject: [merged] mm-mempolicyc-parameter-doc-uniformization.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:51:27 -0700
Message-ID: <5390ca3f.1Y1gdKBVwolnYzia%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56145 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaFETv1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:51:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de, fabf@skynet.be

Subject: [merged] mm-mempolicyc-parameter-doc-uniformization.patch removed from -mm tree
To: fabf@skynet.be,mgorman@suse.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:51:27 -0700


The patch titled
     Subject: mm/mempolicy.c: parameter doc uniformization
has been removed from the -mm tree.  Its filename was
     mm-mempolicyc-parameter-doc-uniformization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: mm/mempolicy.c: parameter doc uniformization

Also fixes kernel-doc warning

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN mm/mempolicy.c~mm-mempolicyc-parameter-doc-uniformization mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicyc-parameter-doc-uniformization
+++ a/mm/mempolicy.c
@@ -1606,9 +1606,9 @@ COMPAT_SYSCALL_DEFINE6(mbind, compat_ulo
 
 /*
  * get_vma_policy(@task, @vma, @addr)
- * @task - task for fallback if vma policy == default
- * @vma   - virtual memory area whose policy is sought
- * @addr  - address in @vma for shared policy lookup
+ * @task: task for fallback if vma policy == default
+ * @vma: virtual memory area whose policy is sought
+ * @addr: address in @vma for shared policy lookup
  *
  * Returns effective policy for a VMA at specified address.
  * Falls back to @task or system default policy, as necessary.
@@ -1854,11 +1854,11 @@ int node_random(const nodemask_t *maskp)
 #ifdef CONFIG_HUGETLBFS
 /*
  * huge_zonelist(@vma, @addr, @gfp_flags, @mpol)
- * @vma = virtual memory area whose policy is sought
- * @addr = address in @vma for shared policy lookup and interleave policy
- * @gfp_flags = for requested zone
- * @mpol = pointer to mempolicy pointer for reference counted mempolicy
- * @nodemask = pointer to nodemask pointer for MPOL_BIND nodemask
+ * @vma: virtual memory area whose policy is sought
+ * @addr: address in @vma for shared policy lookup and interleave policy
+ * @gfp_flags: for requested zone
+ * @mpol: pointer to mempolicy pointer for reference counted mempolicy
+ * @nodemask: pointer to nodemask pointer for MPOL_BIND nodemask
  *
  * Returns a zonelist suitable for a huge page allocation and a pointer
  * to the struct mempolicy for conditional unref after allocation.
@@ -2270,9 +2270,9 @@ static void sp_free(struct sp_node *n)
 /**
  * mpol_misplaced - check whether current page node is valid in policy
  *
- * @page   - page to be checked
- * @vma    - vm area where page mapped
- * @addr   - virtual address where page mapped
+ * @page: page to be checked
+ * @vma: vm area where page mapped
+ * @addr: virtual address where page mapped
  *
  * Lookup current policy node id for vma,addr and "compare to" page's
  * node id.
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-coda-replace-printk-by-pr_foo.patch
fs-coda-logging-prefix-uniformization.patch
fs-coda-use-__func__.patch
fs-hfsplus-bnodec-replace-min-casting-by-min_t.patch
fs-hfsplus-optionsc-replace-seq_printf-by-seq_puts.patch
fs-hfsplus-wrapperc-replace-min-casting-by-min_t.patch
fs-hfsplus-wrapperc-replace-shift-loop-by-ilog2.patch
fs-hfsplus-fix-pr_foo-and-hfs_dbg-formats.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-hpfs-convert-printk-to-pr_foo.patch
fs-hpfs-use-pr_fmt-for-logging.patch
fs-hpfs-use-__func__-for-logging.patch
fs-hpfs-increase-pr_warn-level.patch
documentation-filesystems-seq_filetxt-create_proc_entry-deprecated.patch
fs-proc-task_mmuc-replace-seq_printf-by-seq_puts.patch
fs-proc-vmcorec-remove-null-assignment-on-static.patch
kernel-kexecc-convert-printk-to-pr_foo.patch
kernel-user_namespacec-kernel-doc-checkpatch-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
kernel-profilec-convert-printk-to-pr_foo.patch
kernel-profilec-use-static-const-char-instead-of-static-char.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
fs-cachefiles-convert-printk-to-pr_foo.patch
fs-cachefiles-replace-kerror-by-pr_err.patch
fs-devpts-inodec-convert-printk-to-pr_foo.patch
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
kernel-seccompc-kernel-doc-warning-fix.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-reiserfs-streec-remove-obsolete-__constant.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
fs-dlm-configc-convert-simple_str-to-kstr.patch
fs-dlm-lockspacec-convert-simple_str-to-kstr.patch
fs-dlm-debug_fsc-replace-seq_printf-by-seq_puts.patch
mm-kmemleak-testc-use-pr_fmt-for-logging.patch
ufs-sb-mutex-merge-mutex_destroy.patch

