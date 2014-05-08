From: akpm@linux-foundation.org
Subject: + kernel-tracepointc-kernel-doc-fixes.patch added to -mm tree
Date: Thu, 08 May 2014 13:35:50 -0700
Message-ID: <536beaa6.Pn6bcs8W/bg0WcB3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41283 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbaEHUfu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2014 16:35:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, fabf@skynet.be

Subject: + kernel-tracepointc-kernel-doc-fixes.patch added to -mm tree
To: fabf@skynet.be,rostedt@goodmis.org
From: akpm@linux-foundation.org
Date: Thu, 08 May 2014 13:35:50 -0700


The patch titled
     Subject: kernel/tracepoint.c: kernel-doc fixes
has been added to the -mm tree.  Its filename is
     kernel-tracepointc-kernel-doc-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-tracepointc-kernel-doc-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-tracepointc-kernel-doc-fixes.patch

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
Subject: kernel/tracepoint.c: kernel-doc fixes

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/tracepoint.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/tracepoint.c~kernel-tracepointc-kernel-doc-fixes kernel/tracepoint.c
--- a/kernel/tracepoint.c~kernel-tracepointc-kernel-doc-fixes
+++ a/kernel/tracepoint.c
@@ -239,6 +239,7 @@ static int tracepoint_remove_func(struct
  * tracepoint_probe_register -  Connect a probe to a tracepoint
  * @tp: tracepoint
  * @probe: probe handler
+ * @data: tracepoint data
  *
  * Returns 0 if ok, error value on error.
  * Note: if @tp is within a module, the caller is responsible for
@@ -264,6 +265,7 @@ EXPORT_SYMBOL_GPL(tracepoint_probe_regis
  * tracepoint_probe_unregister -  Disconnect a probe from a tracepoint
  * @tp: tracepoint
  * @probe: probe function pointer
+ * @data: tracepoint data
  *
  * Returns 0 if ok, error value on error.
  */
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch
fs-cifs-remove-obsolete-__constant.patch
fs-jfs-jfs_logmgrc-remove-null-assignment-on-static.patch
fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch
fs-fscache-convert-printk-to-pr_foo.patch
fs-fscache-replace-seq_printf-by-seq_puts.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
ntfs-remove-null-value-assignments.patch
fs-squashfs-squashfsh-replace-pr_warning-by-pr_warn.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix.patch
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
kernel-latencytopc-convert-seq_printf-to-seq_puts.patch
kernel-stop_machinec-kernel-doc-warning-fix.patch
kernel-tracepointc-kernel-doc-fixes.patch
documentation-expand-clarify-debug-documentation.patch
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
kernel-kexecc-convert-printk-to-pr_foo.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
kernel-profilec-convert-printk-to-pr_foo.patch
kernel-profilec-use-static-const-char-instead-of-static-char.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
kernel-seccompc-kernel-doc-warning-fix.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-rcu-treec-make-rcu-node-arrays-static-const-char-const.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
ufs-sb-mutex-merge-mutex_destroy.patch

