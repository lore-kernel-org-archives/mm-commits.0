From: akpm@linux-foundation.org
Subject: [folded-merged]
 nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl-fix.patch removed
 from -mm tree
Date: Thu, 03 Apr 2014 14:13:22 -0700
Message-ID: <533dcef2.pRcd5aFkrT0Y4ICl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbaDCVNX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2014 17:13:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, andreas.rohner@gmx.net, konishi.ryusuke@lab.ntt.co.jp

Subject: [folded-merged] nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl-fix.patch removed from -mm tree
To: konishi.ryusuke@lab.ntt.co.jp,andreas.rohner@gmx.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 03 Apr 2014 14:13:22 -0700


The patch titled
     Subject: nilfs2: add description of NILFS_IOCTL_SET_SUINFO ioctl
has been removed from the -mm tree.  Its filename was
     nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl-fix.patch

This patch was dropped because it was folded into nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl.patch

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: add description of NILFS_IOCTL_SET_SUINFO ioctl

Add description of NILFS_IOCTL_SET_SUINFO ioctl in
Documentation/filesystems/nilfs2.txt to make it up-to-date.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: Andreas Rohner <andreas.rohner@gmx.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/nilfs2.txt |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN Documentation/filesystems/nilfs2.txt~nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl-fix Documentation/filesystems/nilfs2.txt
--- a/Documentation/filesystems/nilfs2.txt~nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl-fix
+++ a/Documentation/filesystems/nilfs2.txt
@@ -111,6 +111,13 @@ Table of NILFS2 specific ioctls
 			        nilfs_resize utilities and by nilfs_cleanerd
 			        daemon.
 
+ NILFS_IOCTL_SET_SUINFO         Modify segment usage info of requested
+				segments. This ioctl is used by
+				nilfs_cleanerd daemon to skip unnecessary
+				cleaning operation of segments and reduce
+				performance penalty or wear of flash device
+				due to redundant move of in-use blocks.
+
  NILFS_IOCTL_GET_SUSTAT         Return segment usage statistics. This ioctl
 			        is used in lssu, nilfs_resize utilities and
 			        by nilfs_cleanerd daemon.
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-update-maintainers-file-entries.patch
nilfs2-add-struct-nilfs_suinfo_update-and-flags.patch
nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage.patch
nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl.patch
nilfs2-add-nilfs_sufile_trim_fs-to-trim-clean-segs.patch
nilfs2-add-fitrim-ioctl-support-for-nilfs2.patch
nilfs2-verify-metadata-sizes-read-from-disk.patch
nilfs2-update-maintainers-file-entries-fix.patch
nilfs2-update-projects-web-site-in-nilfs2txt.patch

