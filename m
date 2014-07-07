From: akpm@linux-foundation.org
Subject: + kernfs-kernel-doc-warning-fix.patch added to -mm tree
Date: Mon, 07 Jul 2014 15:14:47 -0700
Message-ID: <53bb1bd7.t06oOcYVFAkN7Q0J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:41028 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaGGWOs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 18:14:48 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so1072981obb.2
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 15:14:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, gregkh@linuxfoundation.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernfs: kernel-doc warning fix
has been added to the -mm tree.  Its filename is
     kernfs-kernel-doc-warning-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernfs-kernel-doc-warning-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernfs-kernel-doc-warning-fix.patch

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
Subject: kernfs: kernel-doc warning fix

s/static_name/name_is_static

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/kernfs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/kernfs/file.c~kernfs-kernel-doc-warning-fix fs/kernfs/file.c
--- a/fs/kernfs/file.c~kernfs-kernel-doc-warning-fix
+++ a/fs/kernfs/file.c
@@ -896,7 +896,7 @@ const struct file_operations kernfs_file
  * @ops: kernfs operations for the file
  * @priv: private data for the file
  * @ns: optional namespace tag of the file
- * @static_name: don't copy file name
+ * @name_is_static: don't copy file name
  * @key: lockdep key for the file's active_ref, %NULL to disable lockdep
  *
  * Returns the created node on success, ERR_PTR() value on error.
_

Patches currently in -mm which might be from fabf@skynet.be are

kernel-auditfilterc-replace-countsize-kmalloc-by-kcalloc.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
arch-sh-mm-asids-debugfsc-use-ptr_err_or_zero.patch
fs-squashfs-file_directc-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-squashfs-superc-logging-clean-up.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-ocfs2-slot_mapc-replace-countsize-kzalloc-by-kcalloc.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
mm-slabc-add-__init-to-init_lock_keys.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
mm-page_alloc-add-__meminit-to-alloc_pages_exact_nid.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
include-linux-memblockh-add-__init-to-memblock_set_bottom_up.patch
mm-internalh-use-nth_page.patch
mm-hwpoison-injectc-remove-unnecessary-null-test-before-debugfs_remove_recursive.patch
mm-zswapc-add-__init-to-zswap_entry_cache_destroy.patch
lib-test-kstrtoxc-use-array_size-instead-of-sizeof-sizeof.patch
fs-compatc-remove-unnecessary-test-on-unsigned-value.patch
checkpatch-emit-fewer-kmalloc_array-kcalloc-conversion-warnings.patch
fs-efs-nameic-return-is-not-a-function.patch
fs-ramfs-file-nommuc-replace-countsize-kzalloc-by-kcalloc.patch
kernel-test_kprobesc-use-current-logging-functions.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
fs-coda-use-linux-uaccessh.patch
fs-nilfs2-superc-remove-unnecessary-test-on-unsigned-value.patch
fs-ufs-convert-printk-to-pr_foo.patch
fs-ufs-use-pr_fmt.patch
fs-ufs-superc-use-__func__-in-logging.patch
fs-ufs-superc-use-va_format-instead-of-buffer-vsnprintf.patch
fs-ufs-convert-ufsd-printk-to-pr_debug.patch
fs-reiserfs-replace-not-standard-%lu-%ld.patch
fs-reiserfs-use-linux-uaccessh.patch
fs-reiserfs-xattrc-fix-blank-line-missing-after-declarations.patch
fs-hpfs-dnodec-fix-suspect-code-indent.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
proc-constify-seq_operations.patch
fs-exofs-ore_raidc-replace-countsize-kzalloc-by-kcalloc.patch
kernel-gcov-fsc-remove-unnecessary-null-test-before-debugfs_remove.patch
fs-adfs-dir_fplusc-use-array_size-instead-of-sizeof-sizeof.patch
fs-adfs-dir_fplusc-replace-countsize-kzalloc-by-kcalloc.patch
fs-bfs-use-bfs-prefix-for-dump_imap.patch
drivers-parport-parport_ip32c-use-ptr_err_or_zero.patch
fs-pstore-ram_corec-replace-countsize-kmalloc-by-kmalloc_array.patch
fs-cachefiles-daemonc-remove-unnecessary-tests-on-unsigned-values.patch
fs-cachefiles-bindc-remove-unnecessary-assertions.patch
fs-omfs-inodec-replace-countsize-kzalloc-by-kcalloc.patch
fs-romfs-superc-convert-printk-to-pr_foo.patch
fs-romfs-superc-use-pr_fmt-in-logging.patch
fs-romfs-superc-add-blank-line-after-declarations.patch
fs-qnx6-convert-printk-to-pr_foo.patch
fs-qnx6-use-pr_fmt-and-__func__-in-logging.patch
fs-qnx6-update-debugging-to-current-functions.patch
scripts-coccinelle-free-add-null-test-before-freeing-functions.patch
fs-dlm-debug_fsc-remove-unnecessary-null-test-before-debugfs_remove.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
arch-sh-kernel-timec-use-ptr_err_or_zero.patch
fs-quota-kernel-doc-warning-fixes.patch
kernfs-kernel-doc-warning-fix.patch
ntfs-kernel-doc-warning-fixes.patch
ubifs-kernel-doc-warning-fix.patch

