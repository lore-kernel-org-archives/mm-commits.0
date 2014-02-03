From: akpm@linux-foundation.org
Subject: + nilfs2-update-maintainers-file-entries.patch added to -mm tree
Date: Mon, 03 Feb 2014 13:41:12 -0800
Message-ID: <52f00cf8.L98s4p+o5Ncr8eo9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46772 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaBCVlN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Feb 2014 16:41:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, konishi.ryusuke@lab.ntt.co.jp

Subject: + nilfs2-update-maintainers-file-entries.patch added to -mm tree
To: konishi.ryusuke@lab.ntt.co.jp
From: akpm@linux-foundation.org
Date: Mon, 03 Feb 2014 13:41:12 -0800


The patch titled
     Subject: nilfs2: update MAINTAINERS file entries
has been added to the -mm tree.  Its filename is
     nilfs2-update-maintainers-file-entries.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-update-maintainers-file-entries.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-update-maintainers-file-entries.patch

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
Subject: nilfs2: update MAINTAINERS file entries

Update git repository entry of nilfs2 file system and maintainer's
email description.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~nilfs2-update-maintainers-file-entries MAINTAINERS
--- a/MAINTAINERS~nilfs2-update-maintainers-file-entries
+++ a/MAINTAINERS
@@ -6085,10 +6085,10 @@ F:	include/uapi/linux/nfs*
 F:	include/uapi/linux/sunrpc/
 
 NILFS2 FILESYSTEM
-M:	KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
+M:	Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
 L:	linux-nilfs@vger.kernel.org
 W:	http://www.nilfs.org/en/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git
+T:	git git://github.com/konis/nilfs2.git
 S:	Supported
 F:	Documentation/filesystems/nilfs2.txt
 F:	fs/nilfs2/
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-update-maintainers-file-entries.patch
nilfs2-add-struct-nilfs_suinfo_update-and-flags.patch
nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage.patch
nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl.patch

