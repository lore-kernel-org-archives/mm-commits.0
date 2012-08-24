From: akpm@linux-foundation.org
Subject: [merged] documentation-update-mount-option-in-filesystem-vfattxt.patch removed from -mm tree
Date: Fri, 24 Aug 2012 11:41:09 -0700
Message-ID: <20120824184109.A6B30100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:50983 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760031Ab2HXSlL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Aug 2012 14:41:11 -0400
Received: by qcqs25 with SMTP id s25so312302qcq.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2012 11:41:10 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linkinjeon@gmail.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: update mount option in filesystem/vfat.txt
has been removed from the -mm tree.  Its filename was
     documentation-update-mount-option-in-filesystem-vfattxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: Documentation: update mount option in filesystem/vfat.txt

Update two mount options(discard, nfs) in vfat.txt.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/vfat.txt |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN Documentation/filesystems/vfat.txt~documentation-update-mount-option-in-filesystem-vfattxt Documentation/filesystems/vfat.txt
--- a/Documentation/filesystems/vfat.txt~documentation-update-mount-option-in-filesystem-vfattxt
+++ a/Documentation/filesystems/vfat.txt
@@ -137,6 +137,17 @@ errors=panic|continue|remount-ro
 		 without doing anything or remount the partition in
 		 read-only mode (default behavior).
 
+discard       -- If set, issues discard/TRIM commands to the block
+		 device when blocks are freed. This is useful for SSD devices
+		 and sparse/thinly-provisoned LUNs.
+
+nfs           -- This option maintains an index (cache) of directory
+		 inodes by i_logstart which is used by the nfs-related code to
+		 improve look-ups.
+
+		 Enable this only if you want to export the FAT filesystem
+		 over NFS
+
 <bool>: 0,1,yes,no,true,false
 
 TODO
_

Patches currently in -mm which might be from linkinjeon@gmail.com are

origin.patch
linux-next.patch
fat-use-accessor-function-for-msdos_dir_entry-start.patch

