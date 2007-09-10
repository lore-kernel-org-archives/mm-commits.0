From: akpm@linux-foundation.org
Subject: + documentation-add-entries-to-filesystems-00-index-for-several-untracked-files.patch added to -mm tree
Date: Mon, 10 Sep 2007 01:48:03 -0700
Message-ID: <200709100848.l8A8m3Iw015942@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41985 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755890AbXIJIsS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Sep 2007 04:48:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: crquan@gmail.com, rdunlap@xenotime.net, rob@landley.net


The patch titled
     Documentation: add entries to filesystems/00-INDEX for several untracked files
has been added to the -mm tree.  Its filename is
     documentation-add-entries-to-filesystems-00-index-for-several-untracked-files.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-gfs2-nmw.patch
git-netdev-all.patch
git-net.patch
nbd-use-list_for_each_entry_safe-to-make-it-more-consolidated-and-readable.patch
nbd-change-a-parameters-type-to-remove-a-memcpy-call.patch
fs-use-kmem_cache_zalloc-instead.patch
fs-remove-the-unused-mempages-parameter.patch
documentation-add-entries-to-filesystems-00-index-for-several-untracked-files.patch
