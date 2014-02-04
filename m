From: akpm@linux-foundation.org
Subject: + nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl-fix.patch added to -mm tree
Date: Tue, 04 Feb 2014 13:38:32 -0800
Message-ID: <52f15dd8.U3k9OKE2YRjt0eVj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57686 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935366AbaBDVid (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Feb 2014 16:38:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, andreas.rohner@gmx.net, konishi.ryusuke@lab.ntt.co.jp

Subject: + nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl-fix.patch added to -mm tree
To: konishi.ryusuke@lab.ntt.co.jp,andreas.rohner@gmx.net
From: akpm@linux-foundation.org
Date: Tue, 04 Feb 2014 13:38:32 -0800


The patch titled
     Subject: nilfs2: add description of NILFS_IOCTL_SET_SUINFO ioctl
has been added to the -mm tree.  Its filename is
     nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl-fix.patch

