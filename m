From: akpm@linux-foundation.org
Subject: [merged] lib-vsprintfc-fix-comparison-to-bool.patch removed from
 -mm tree
Date: Thu, 05 Jun 2014 13:05:15 -0700
Message-ID: <5390cd7b.VOlGljoSNVJ8aZJB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaFEUFQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 16:05:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: [merged] lib-vsprintfc-fix-comparison-to-bool.patch removed from -mm tree
To: fabf@skynet.be,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 13:05:15 -0700


The patch titled
     Subject: lib/vsprintf.c: fix comparison to bool
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-fix-comparison-to-bool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: lib/vsprintf.c: fix comparison to bool

Fixing 2 coccinelle warnings:
lib/vsprintf.c:2350:2-9: WARNING: Assignment of bool to 0/1
lib/vsprintf.c:2389:3-10: WARNING: Assignment of bool to 0/1

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-fix-comparison-to-bool lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-fix-comparison-to-bool
+++ a/lib/vsprintf.c
@@ -2347,7 +2347,7 @@ int vsscanf(const char *buf, const char
 			break;
 
 		base = 10;
-		is_sign = 0;
+		is_sign = false;
 
 		switch (*fmt++) {
 		case 'c':
@@ -2386,7 +2386,7 @@ int vsscanf(const char *buf, const char
 		case 'i':
 			base = 0;
 		case 'd':
-			is_sign = 1;
+			is_sign = true;
 		case 'u':
 			break;
 		case '%':
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

