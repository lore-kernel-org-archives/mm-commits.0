From: akpm@linux-foundation.org
Subject: [patch 1/4] MAINTAINERS, nilfs2: change project home URLs
Date: Fri, 12 Jan 2018 16:53:07 -0800
Message-ID: <5a595873.DrovgqhRBi8KUfcS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46222 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965265AbeAMAxI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 Jan 2018 19:53:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, konishi.ryusuke@lab.ntt.co.jp

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
