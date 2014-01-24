From: akpm@linux-foundation.org
Subject: [merged] documentation-blockdev-ramdisktxt-updates.patch removed
 from -mm tree
Date: Fri, 24 Jan 2014 11:03:16 -0800
Message-ID: <52e2b8f4.oPn6zwYU1nK9u5i8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbaAXTDQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:03:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@infradead.org, fabf@skynet.be

Subject: [merged] documentation-blockdev-ramdisktxt-updates.patch removed from -mm tree
To: fabf@skynet.be,rdunlap@infradead.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:03:16 -0800


The patch titled
     Subject: Documentation/blockdev/ramdisk.txt: updates
has been removed from the -mm tree.  Its filename was
     documentation-blockdev-ramdisktxt-updates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: Documentation/blockdev/ramdisk.txt: updates

- ramdisk_blocksize doesn't exist anymore

- Module parameters added to documentation

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/blockdev/ramdisk.txt |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff -puN Documentation/blockdev/ramdisk.txt~documentation-blockdev-ramdisktxt-updates Documentation/blockdev/ramdisk.txt
--- a/Documentation/blockdev/ramdisk.txt~documentation-blockdev-ramdisktxt-updates
+++ a/Documentation/blockdev/ramdisk.txt
@@ -36,21 +36,30 @@ allowing one to squeeze more programs on
 rescue floppy disk.
 
 
-2) Kernel Command Line Parameters
+2) Parameters
 ---------------------------------
 
+2a) Kernel Command Line Parameters
+
 	ramdisk_size=N
 	==============
 
 This parameter tells the RAM disk driver to set up RAM disks of N k size.  The
-default is 4096 (4 MB) (8192 (8 MB) on S390).
+default is 4096 (4 MB).
+
+2b) Module parameters
 
-	ramdisk_blocksize=N
-	===================
+	rd_nr
+	=====
+	/dev/ramX devices created.
 
-This parameter tells the RAM disk driver how many bytes to use per block.  The
-default is 1024 (BLOCK_SIZE).
+	max_part
+	========
+	Maximum partition number.
 
+	rd_size
+	=======
+	See ramdisk_size.
 
 3) Using "rdev -r"
 ------------------
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
ufs-sb-mutex-merge-mutex_destroy.patch

