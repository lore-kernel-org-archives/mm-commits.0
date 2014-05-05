From: akpm@linux-foundation.org
Subject: + mm-mempolicyc-parameter-doc-uniformization.patch added to -mm
 tree
Date: Mon, 05 May 2014 14:03:29 -0700
Message-ID: <5367fca1.eGfx78pfNlKwirAC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755132AbaEEVD3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2014 17:03:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de, fabf@skynet.be

Subject: + mm-mempolicyc-parameter-doc-uniformization.patch added to -mm tree
To: fabf@skynet.be,mgorman@suse.de
From: akpm@linux-foundation.org
Date: Mon, 05 May 2014 14:03:29 -0700


The patch titled
     Subject: mm/mempolicy.c: parameter doc uniformization
has been added to the -mm tree.  Its filename is
     mm-mempolicyc-parameter-doc-uniformization.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicyc-parameter-doc-uniformization.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicyc-parameter-doc-uniformization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1556,9 +1556,9 @@ COMPAT_SYSCALL_DEFINE6(mbind, compat_ulo
 
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
@@ -1804,11 +1804,11 @@ int node_random(const nodemask_t *maskp)
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
@@ -2220,9 +2220,9 @@ static void sp_free(struct sp_node *n)
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

fs-affs-superc-bugfix-double-free.patch
fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-jfs-jfs_logmgrc-remove-null-assignment-on-static.patch
fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch
fs-fscache-convert-printk-to-pr_foo.patch
ntfs-remove-null-value-assignments.patch
fs-squashfs-squashfsh-replace-pr_warning-by-pr_warn.patch
fs-configs-itemc-kernel-doc-fixes-clean-up.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
fs-9p-kerneldoc-fixes.patch
mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
mm-memory_hotplugc-use-pfn_down.patch
mm-memblockc-use-pfn_down.patch
mm-memcontrolc-remove-null-assignment-on-static.patch
mm-vmallocc-replace-seq_printf-by-seq_puts.patch
mm-mempolicyc-parameter-doc-uniformization.patch
mm-zbudc-make-size-unsigned-like-unique-callsite.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
kernel-cpuc-convert-printk-to-pr_foo.patch
kernel-backtracetestc-replace-no-level-printk-by-pr_info.patch
kernel-capabilityc-code-clean-up.patch
kernel-exec_domainc-code-clean-up.patch
lib-libcrc32cc-use-ptr_err_or_zero.patch
lib-vsprintfc-fix-comparison-to-bool.patch
kernel-compatc-use-sizeof-instead-of-sizeof.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-reiserfs-streec-remove-obsolete-__constant.patch
kernel-cpusetc-kernel-doc-fixes.patch
kernel-cpusetc-convert-printk-to-pr_foo.patch
kernel-kexecc-convert-printk-to-pr_foo.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
init-mainc-code-clean-up.patch
ufs-sb-mutex-merge-mutex_destroy.patch

