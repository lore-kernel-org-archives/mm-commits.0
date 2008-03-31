From: akpm@linux-foundation.org
Subject: - ext3-dont-export-ext3_fsh-and-jbdh.patch removed from -mm tree
Date: Mon, 31 Mar 2008 13:17:54 -0700
Message-ID: <200803312017.m2VKHsX7024001@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33467 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756288AbYCaUTA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 31 Mar 2008 16:19:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     ext3: don't export ext3_fs.h and jbd.h
has been removed from the -mm tree.  Its filename was
     ext3-dont-export-ext3_fsh-and-jbdh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3: don't export ext3_fs.h and jbd.h
From: Christoph Hellwig <hch@lst.de>

Neither of the headers actually compiles when included from userpsace nor
should it be made available as userspace tools should be using the libraries
or at least headers from e2fsprogs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/Kbuild |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/Kbuild~ext3-dont-export-ext3_fsh-and-jbdh include/linux/Kbuild
--- a/include/linux/Kbuild~ext3-dont-export-ext3_fsh-and-jbdh
+++ a/include/linux/Kbuild
@@ -195,7 +195,6 @@ unifdef-y += ethtool.h
 unifdef-y += eventpoll.h
 unifdef-y += signalfd.h
 unifdef-y += ext2_fs.h
-unifdef-y += ext3_fs.h
 unifdef-y += fb.h
 unifdef-y += fcntl.h
 unifdef-y += filter.h
@@ -248,7 +247,6 @@ unifdef-y += isdn.h
 unifdef-y += isdnif.h
 unifdef-y += isdn_divertif.h
 unifdef-y += isdn_ppp.h
-unifdef-y += jbd.h
 unifdef-y += joystick.h
 unifdef-y += kdev_t.h
 unifdef-y += kd.h
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
git-gfs2-nmw.patch
git-udf.patch
git-unionfs.patch
git-vfs.patch
vfs-remove-lives_below_in_same_fs.patch
signals-do_tkill-dont-use-tasklist_lock-comment.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
mxser-convert-large-macros-to-functions.patch
reiserfs-use-open_bdev_excl.patch

