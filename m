From: akpm@linux-foundation.org
Subject: [merged] fs-hfs-hfs_fsh-remove-redundant-sys_tz-declaration.patch removed from -mm tree
Date: Tue, 14 Oct 2014 11:21:06 -0700
Message-ID: <543d6992.rpFsNHr50eJKljMg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbaJNSVE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:21:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/hfs/hfs_fs.h: remove redundant sys_tz declaration
has been removed from the -mm tree.  Its filename was
     fs-hfs-hfs_fsh-remove-redundant-sys_tz-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
