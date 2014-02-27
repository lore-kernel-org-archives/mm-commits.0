From: akpm@linux-foundation.org
Subject: + nilfs2-update-maintainers-file-entries-fix.patch added to -mm
 tree
Date: Wed, 26 Feb 2014 16:22:48 -0800
Message-ID: <530e8558.UeeUZ4AT59lbIs9w%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54061 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbaB0AWt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Feb 2014 19:22:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, konishi.ryusuke@lab.ntt.co.jp

Subject: + nilfs2-update-maintainers-file-entries-fix.patch added to -mm tree
To: konishi.ryusuke@lab.ntt.co.jp
From: akpm@linux-foundation.org
Date: Wed, 26 Feb 2014 16:22:48 -0800


The patch titled
     Subject: nilfs2: update MAINTAINERS file entries fix
has been added to the -mm tree.  Its filename is
     nilfs2-update-maintainers-file-entries-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-update-maintainers-file-entries-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-update-maintainers-file-entries-fix.patch

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
Subject: nilfs2: update MAINTAINERS file entries fix

Also, web-page entry is updated according to relocation of project's
web site.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~nilfs2-update-maintainers-file-entries-fix MAINTAINERS
--- a/MAINTAINERS~nilfs2-update-maintainers-file-entries-fix
+++ a/MAINTAINERS
@@ -6105,7 +6105,7 @@ F:	include/uapi/linux/sunrpc/
 NILFS2 FILESYSTEM
 M:	Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
 L:	linux-nilfs@vger.kernel.org
-W:	http://www.nilfs.org/en/
+W:	http://nilfs.sourceforge.net/
 T:	git git://github.com/konis/nilfs2.git
 S:	Supported
 F:	Documentation/filesystems/nilfs2.txt
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

nilfs2-update-maintainers-file-entries.patch
nilfs2-add-struct-nilfs_suinfo_update-and-flags.patch
nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage.patch
nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage-fix.patch
nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl.patch
nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl-fix.patch
nilfs2-add-nilfs_sufile_trim_fs-to-trim-clean-segs.patch
nilfs2-add-fitrim-ioctl-support-for-nilfs2.patch
nilfs2-verify-metadata-sizes-read-from-disk.patch
nilfs2-update-maintainers-file-entries-fix.patch
nilfs2-update-projects-web-site-in-nilfs2txt.patch

