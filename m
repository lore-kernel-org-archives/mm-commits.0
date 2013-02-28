From: akpm@linux-foundation.org
Subject: [folded-dropped] fs-proc-clean-up-printks-fix-fix.patch removed from -mm tree
Date: Wed, 27 Feb 2013 16:39:57 -0800
Message-ID: <20130228003957.D8EF331C071@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:35792 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3B1Aj6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:39:58 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so138581ghb.0
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:39:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-proc-clean-up-printks-fix-fix
has been removed from the -mm tree.  Its filename was
     fs-proc-clean-up-printks-fix-fix.patch

This patch was dropped because it was folded into fs-proc-clean-up-printks.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-proc-clean-up-printks-fix-fix

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c     |    4 ++--
 fs/proc/proc_sysctl.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/proc/generic.c~fs-proc-clean-up-printks-fix-fix fs/proc/generic.c
--- a/fs/proc/generic.c~fs-proc-clean-up-printks-fix-fix
+++ a/fs/proc/generic.c
@@ -829,8 +829,8 @@ void remove_proc_entry(const char *name,
 		parent->nlink--;
 	de->nlink = 0;
 	WARN(de->subdir, "%s: removing non-empty directory "
-			"'%s/%s', leaking at least '%s'\n", __func__,
-			de->parent->name, de->name, de->subdir->name);
+			 "'%s/%s', leaking at least '%s'\n", __func__,
+			 de->parent->name, de->name, de->subdir->name);
 	pde_put(de);
 }
 EXPORT_SYMBOL(remove_proc_entry);
diff -puN fs/proc/proc_sysctl.c~fs-proc-clean-up-printks-fix-fix fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~fs-proc-clean-up-printks-fix-fix
+++ a/fs/proc/proc_sysctl.c
@@ -997,7 +997,7 @@ static int sysctl_err(const char *path, 
 	vaf.va = &args;
 
 	pr_err("sysctl table check failed: %s/%s %pV\n",
-			path, table->procname, &vaf);
+	       path, table->procname, &vaf);
 
 	va_end(args);
 	return -EINVAL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-use-vm_unmapped_area-on-parisc-architecture.patch
backlight-add-new-lp8788-backlight-driver.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
fs-proc-clean-up-printks.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix.patch
lockdep-check-that-no-locks-held-at-freeze-time-fix.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes.patch
idr-remove-length-restriction-from-idr_layer-bitmap-checkpatch-fixes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
selftests-add-tests-for-efivarfs-fix.patch
selftests-add-tests-for-efivarfs-fix-fix.patch
tools-testing-selftests-makefile-rearrange-targets.patch
selftests-add-a-simple-doc-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch
hlist-drop-the-node-parameter-from-iterators-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix-fix.patch

