From: akpm@linux-foundation.org
Subject: + nilfs2-update-projects-web-site-in-nilfs2txt.patch added to -mm tree
Date: Wed, 26 Feb 2014 16:22:49 -0800
Message-ID: <530e8559.AGEcpCTrPahi1McL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186AbaB0AWu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Feb 2014 19:22:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, konishi.ryusuke@lab.ntt.co.jp

Subject: + nilfs2-update-projects-web-site-in-nilfs2txt.patch added to -mm tree
To: konishi.ryusuke@lab.ntt.co.jp
From: akpm@linux-foundation.org
Date: Wed, 26 Feb 2014 16:22:49 -0800


The patch titled
     Subject: nilfs2: update project's web site in nilfs2.txt
has been added to the -mm tree.  Its filename is
     nilfs2-update-projects-web-site-in-nilfs2txt.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-update-projects-web-site-in-nilfs2txt.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-update-projects-web-site-in-nilfs2txt.patch

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
Subject: nilfs2: update project's web site in nilfs2.txt

Project's web site was moved to nilfs.sourceforge.net from
www.nilfs.org.  This updates the site information in
Documentation/filesystems/nilfs2.txt with the new location.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/nilfs2.txt |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN Documentation/filesystems/nilfs2.txt~nilfs2-update-projects-web-site-in-nilfs2txt Documentation/filesystems/nilfs2.txt
--- a/Documentation/filesystems/nilfs2.txt~nilfs2-update-projects-web-site-in-nilfs2txt
+++ a/Documentation/filesystems/nilfs2.txt
@@ -25,9 +25,8 @@ available from the following download pa
 cleaner or garbage collector) are required.  Details on the tools are
 described in the man pages included in the package.
 
-Project web page:    http://www.nilfs.org/en/
-Download page:       http://www.nilfs.org/en/download.html
-Git tree web page:   http://www.nilfs.org/git/
+Project web page:    http://nilfs.sourceforge.net/
+Download page:       http://nilfs.sourceforge.net/en/download.html
 List info:           http://vger.kernel.org/vger-lists.html#linux-nilfs
 
 Caveats
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

