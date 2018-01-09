From: akpm@linux-foundation.org
Subject: + maintainers-nilfs2-change-project-home-urls.patch added to -mm
 tree
Date: Mon, 08 Jan 2018 16:28:14 -0800
Message-ID: <5a540c9e.BWN1pNUv+jESOjpR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44438 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752264AbeAIA2P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jan 2018 19:28:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS, nilfs2: change project home URLs
has been added to the -mm tree.  Its filename is
     maintainers-nilfs2-change-project-home-urls.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-nilfs2-change-project-home-urls.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-nilfs2-change-project-home-urls.patch

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
Subject: MAINTAINERS, nilfs2: change project home URLs

The domain of NILFS project home was changed to "nilfs.sourceforge.io" to
enable https access (the previous domain "nilfs.sourceforge.net" is
redirected to the new one).  Modify URLs of the project home to reflect
this change and to replace their protocol from http to https.

Link: http://lkml.kernel.org/r/1515416141-5614-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/nilfs2.txt |    4 ++--
 MAINTAINERS                          |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN Documentation/filesystems/nilfs2.txt~maintainers-nilfs2-change-project-home-urls Documentation/filesystems/nilfs2.txt
--- a/Documentation/filesystems/nilfs2.txt~maintainers-nilfs2-change-project-home-urls
+++ a/Documentation/filesystems/nilfs2.txt
@@ -25,8 +25,8 @@ available from the following download pa
 cleaner or garbage collector) are required.  Details on the tools are
 described in the man pages included in the package.
 
-Project web page:    http://nilfs.sourceforge.net/
-Download page:       http://nilfs.sourceforge.net/en/download.html
+Project web page:    https://nilfs.sourceforge.io/
+Download page:       https://nilfs.sourceforge.io/en/download.html
 List info:           http://vger.kernel.org/vger-lists.html#linux-nilfs
 
 Caveats
diff -puN MAINTAINERS~maintainers-nilfs2-change-project-home-urls MAINTAINERS
--- a/MAINTAINERS~maintainers-nilfs2-change-project-home-urls
+++ a/MAINTAINERS
@@ -9638,8 +9638,8 @@ F:	include/uapi/linux/sunrpc/
 NILFS2 FILESYSTEM
 M:	Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
 L:	linux-nilfs@vger.kernel.org
-W:	http://nilfs.sourceforge.net/
-W:	http://nilfs.osdn.jp/
+W:	https://nilfs.sourceforge.io/
+W:	https://nilfs.osdn.jp/
 T:	git git://github.com/konis/nilfs2.git
 S:	Supported
 F:	Documentation/filesystems/nilfs2.txt
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

maintainers-nilfs2-change-project-home-urls.patch

