From: akpm@linux-foundation.org
Subject: - documentation-add-entries-to-filesystems-00-index-for-several-untracked-files.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:04:15 -0700
Message-ID: <200710180704.l9I74Fl6031535@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49571 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760737AbXJRH0z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:26:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: crquan@gmail.com, rdunlap@xenotime.net, rob@landley.net, mm-commits@vger.kernel.org


The patch titled
     Documentation: add entries to filesystems/00-INDEX for several untracked files
has been removed from the -mm tree.  Its filename was
     documentation-add-entries-to-filesystems-00-index-for-several-untracked-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Documentation: add entries to filesystems/00-INDEX for several untracked files
From: Denis Cheng <crquan@gmail.com>

Signed-off-by: Denis Cheng <crquan@gmail.com>
Cc: Rob Landley <rob@landley.net>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/00-INDEX |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN Documentation/filesystems/00-INDEX~documentation-add-entries-to-filesystems-00-index-for-several-untracked-files Documentation/filesystems/00-INDEX
--- a/Documentation/filesystems/00-INDEX~documentation-add-entries-to-filesystems-00-index-for-several-untracked-files
+++ a/Documentation/filesystems/00-INDEX
@@ -44,10 +44,16 @@ files.txt
 	- info on file management in the Linux kernel.
 fuse.txt
 	- info on the Filesystem in User SpacE including mount options.
+gfs2.txt
+	- info on the Global File System 2.
 hfs.txt
 	- info on the Macintosh HFS Filesystem for Linux.
+hfsplus.txt
+	- info on the Macintosh HFSPlus Filesystem for Linux.
 hpfs.txt
 	- info and mount options for the OS/2 HPFS.
+inotify.txt
+	- info on the powerful yet simple file change notification system.
 isofs.txt
 	- info and mount options for the ISO 9660 (CDROM) filesystem.
 jfs.txt
_

Patches currently in -mm which might be from crquan@gmail.com are

origin.patch
