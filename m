From: akpm@linux-foundation.org
Subject: + fs-hfs-hfs_fsh-remove-redundant-sys_tz-declaration.patch added
 to -mm tree
Date: Wed, 01 Oct 2014 15:29:38 -0700
Message-ID: <542c8052.9AGaRvdIRlUmQ1Po%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45132 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbaJAW3i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 18:29:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/hfs/hfs_fs.h: remove redundant sys_tz declaration
has been added to the -mm tree.  Its filename is
     fs-hfs-hfs_fsh-remove-redundant-sys_tz-declaration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-hfs-hfs_fsh-remove-redundant-sys_tz-declaration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-hfs-hfs_fsh-remove-redundant-sys_tz-declaration.patch

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
Subject: fs/hfs/hfs_fs.h: remove redundant sys_tz declaration

sys_tz is already declared in include/linux/time.h

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/hfs_fs.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/hfs/hfs_fs.h~fs-hfs-hfs_fsh-remove-redundant-sys_tz-declaration fs/hfs/hfs_fs.h
--- a/fs/hfs/hfs_fs.h~fs-hfs-hfs_fsh-remove-redundant-sys_tz-declaration
+++ a/fs/hfs/hfs_fs.h
@@ -242,8 +242,6 @@ extern int hfs_mac2asc(struct super_bloc
 /* super.c */
 extern void hfs_mark_mdb_dirty(struct super_block *sb);
 
-extern struct timezone sys_tz;
-
 /*
  * There are two time systems.  Both are based on seconds since
  * a particular time/date.
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-ufs-ballocc-remove-unused-variable.patch
fs-reiserfs-journalc-fix-sparse-context-imbalance-warning.patch
fat-remove-redundant-sys_tz-declaration.patch
fs-affs-superc-remove-unused-variable.patch
fs-affs-inodec-remove-unused-variable.patch
fs-affs-filec-fix-shadow-warnings.patch
fs-omfs-block-number-sanity-check-during-fill_super-operation.patch
linux-next.patch
fs-hfs-hfs_fsh-remove-redundant-sys_tz-declaration.patch
fs-ncpfs-dirc-remove-redundant-sys_tz-declaration.patch
fs-affs-remove-redundant-sys_tz-declarations.patch

