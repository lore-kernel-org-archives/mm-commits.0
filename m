From: akpm@linux-foundation.org
Subject: + ext4-superc-fix-ifdefs.patch added to -mm tree
Date: Mon, 05 Nov 2007 13:17:24 -0800
Message-ID: <200711052117.lA5LHO3T020175@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47965 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754039AbXKEVRl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 16:17:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, rpjday@mindspring.com


The patch titled
     ext4/super.c: fix #ifdef's
has been added to the -mm tree.  Its filename is
     ext4-superc-fix-ifdefs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext4/super.c: fix #ifdef's
From: Adrian Bunk <bunk@kernel.org>

Fix the names of two variables in #ifdef's.

Based on a report by Robert P. J. Day.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ext4/super.c~ext4-superc-fix-ifdefs fs/ext4/super.c
--- a/fs/ext4/super.c~ext4-superc-fix-ifdefs
+++ a/fs/ext4/super.c
@@ -709,7 +709,7 @@ static int ext4_show_options(struct seq_
 		seq_puts(seq, ",debug");
 	if (test_opt(sb, OLDALLOC))
 		seq_puts(seq, ",oldalloc");
-#ifdef CONFIG_EXT4_FS_XATTR
+#ifdef CONFIG_EXT4DEV_FS_XATTR
 	if (test_opt(sb, XATTR_USER))
 		seq_puts(seq, ",user_xattr");
 	if (!test_opt(sb, XATTR_USER) &&
@@ -717,7 +717,7 @@ static int ext4_show_options(struct seq_
 		seq_puts(seq, ",nouser_xattr");
 	}
 #endif
-#ifdef CONFIG_EXT4_FS_POSIX_ACL
+#ifdef CONFIG_EXT4DEV_FS_POSIX_ACL
 	if (test_opt(sb, POSIX_ACL))
 		seq_puts(seq, ",acl");
 	if (!test_opt(sb, POSIX_ACL) && (def_mount_opts & EXT4_DEFM_ACL))
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
fs-afs-vlocationc-fix-off-by-one.patch
lguest_userc-fix-memory-leak.patch
video-sis-fix-negative-array-index.patch
git-dvb.patch
git-hwmon.patch
git-input.patch
make-jffs2_get_acl-static.patch
make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-ocfs2.patch
git-sh64.patch
scsi-advansysc-make-3-functions-static.patch
git-block.patch
xtensa-iss_net_setup-must-be-__init.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
pidns-place-under-config_experimental.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
feature-removal-schedule-remove-sa_-flags-entry.patch
kernel-taskstatsc-fix-bogus-nlmsg_free.patch
mm-hugetlbc-make-a-function-static.patch
mm-page-writebackc-make-a-function-static.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
scheduled-oss-driver-removal.patch
cleanup-after-apus-removal.patch
53c7xx-removal-fallout.patch
remove-mm_ptovvtop.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
ext4-superc-fix-ifdefs.patch
make-jbd-journalc__journal_abort_hard-static.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
reiser4.patch
