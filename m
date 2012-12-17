From: akpm@linux-foundation.org
Subject: [folded-merged] fs-notify-add-procfs-fdinfo-helper-v7-add-missing-space-after-prefix.patch removed from -mm tree
Date: Mon, 17 Dec 2012 15:49:43 -0800
Message-ID: <20121217234944.98A0D200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:58781 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab2LQXts (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Dec 2012 18:49:48 -0500
Received: by mail-we0-f202.google.com with SMTP id t57so354822wey.3
        for <mm-commits@vger.kernel.org>; Mon, 17 Dec 2012 15:49:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@openvz.org, adobriyan@gmail.com, aneesh.kumar@linux.vnet.ibm.com, avagin@openvz.org, bfields@fieldses.org, jbottomley@parallels.com, matt.helsley@gmail.com, oleg@redhat.com, tvrtko.ursulin@onelan.co.uk, viro@ZenIV.linux.org.uk, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, notify: add missing space after prefix
has been removed from the -mm tree.  Its filename was
     fs-notify-add-procfs-fdinfo-helper-v7-add-missing-space-after-prefix.patch

This patch was dropped because it was folded into fs-notify-add-procfs-fdinfo-helper-v7.patch

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: fs, notify: add missing space after prefix

While being prepared the first series I occasionally left "inotify-wd"
token not updated.  This patch fixes it and bring space between prefix and
the rest of line back.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: James Bottomley <jbottomley@parallels.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Matthew Helsley <matt.helsley@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fdinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/notify/fdinfo.c~fs-notify-add-procfs-fdinfo-helper-v7-add-missing-space-after-prefix fs/notify/fdinfo.c
--- a/fs/notify/fdinfo.c~fs-notify-add-procfs-fdinfo-helper-v7-add-missing-space-after-prefix
+++ a/fs/notify/fdinfo.c
@@ -86,7 +86,7 @@ static int inotify_fdinfo(struct seq_fil
 	inode_mark = container_of(mark, struct inotify_inode_mark, fsn_mark);
 	inode = igrab(mark->i.inode);
 	if (inode) {
-		ret = seq_printf(m, "inotify-wd:%x ino:%lx sdev:%x "
+		ret = seq_printf(m, "inotify wd:%x ino:%lx sdev:%x "
 				 "mask:%x ignored_mask:%x ",
 				 inode_mark->wd, inode->i_ino,
 				 inode->i_sb->s_dev,
_

Patches currently in -mm which might be from gorcunov@openvz.org are

origin.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
proc-pid-status-add-seccomp-field.patch
kcmp-selftests-make-run_tests-fix.patch
kcmp-selftests-print-fail-status-instead-of-cause-make-error.patch
tools-testing-selftests-kcmp-kcmp_testc-print-reason-for-failure-in-kcmp_test.patch
procfs-add-ability-to-plug-in-auxiliary-fdinfo-providers.patch
fs-eventfd-add-procfs-fdinfo-helper.patch
fs-epoll-add-procfs-fdinfo-helper-v2.patch
fs-exportfs-escape-nil-dereference-if-no-s_export_op-present.patch
fs-exportfs-add-exportfs_encode_inode_fh-helper.patch
fs-notify-add-procfs-fdinfo-helper-v7.patch
fs-notify-add-procfs-fdinfo-helper-v7-dont-forget-to-provide-fhandle-for-inode-fanotify.patch
fs-notify-add-procfs-fdinfo-helper-v7-fs-fanotify-ddd-missing-pieces-in-fdinfo-for-ability-to-call-fanotify_init.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output.patch
docs-add-documentation-about-proc-pid-fdinfo-fd-output-fix.patch
fs-fanotify-add-mflags-field-to-fanotify-output.patch
docs-update-documentation-about-proc-pid-fdinfo-fd-fanotify-output.patch

