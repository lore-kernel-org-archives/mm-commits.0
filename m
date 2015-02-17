From: akpm@linux-foundation.org
Subject: + ocfs2-update-web-page-git-tree-in-documentation.patch added to
 -mm tree
Date: Tue, 17 Feb 2015 14:05:50 -0800
Message-ID: <54e3bb3e.NzeFq9e71/SLEBU3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36803 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbbBQWFv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 17:05:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mfasheh@suse.de, jlbec@evilplan.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: update web page + git tree in documentation
has been added to the -mm tree.  Its filename is
     ocfs2-update-web-page-git-tree-in-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-update-web-page-git-tree-in-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-update-web-page-git-tree-in-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mark Fasheh <mfasheh@suse.de>
Subject: ocfs2: update web page + git tree in documentation

We (the Ocfs2 project) recently moved the location of our ocfs2-tools git
tree and project web page.  The pertinent discussion can be seen here:

https://oss.oracle.com/pipermail/ocfs2-devel/2015-February/010579.html

The following patch updates the Ocfs2 documentation in MAINTAINERS,
ocfs2.txt, and dlmfs.txt.  I added our new official web page, changed the
location of our tools git tree and removed the link to Joel's ancient
kernel git tree - Andrew has handled our patches for a while now.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/dlmfs.txt |    4 ++--
 Documentation/filesystems/ocfs2.txt |    4 ++--
 MAINTAINERS                         |    3 +--
 3 files changed, 5 insertions(+), 6 deletions(-)

diff -puN Documentation/filesystems/dlmfs.txt~ocfs2-update-web-page-git-tree-in-documentation Documentation/filesystems/dlmfs.txt
--- a/Documentation/filesystems/dlmfs.txt~ocfs2-update-web-page-git-tree-in-documentation
+++ a/Documentation/filesystems/dlmfs.txt
@@ -5,8 +5,8 @@ system.
 
 dlmfs is built with OCFS2 as it requires most of its infrastructure.
 
-Project web page:    http://oss.oracle.com/projects/ocfs2
-Tools web page:      http://oss.oracle.com/projects/ocfs2-tools
+Project web page:    http://ocfs2.wiki.kernel.org
+Tools web page:      https://github.com/markfasheh/ocfs2-tools
 OCFS2 mailing lists: http://oss.oracle.com/projects/ocfs2/mailman/
 
 All code copyright 2005 Oracle except when otherwise noted.
diff -puN Documentation/filesystems/ocfs2.txt~ocfs2-update-web-page-git-tree-in-documentation Documentation/filesystems/ocfs2.txt
--- a/Documentation/filesystems/ocfs2.txt~ocfs2-update-web-page-git-tree-in-documentation
+++ a/Documentation/filesystems/ocfs2.txt
@@ -8,8 +8,8 @@ also make it attractive for non-clustere
 You'll want to install the ocfs2-tools package in order to at least
 get "mount.ocfs2" and "ocfs2_hb_ctl".
 
-Project web page:    http://oss.oracle.com/projects/ocfs2
-Tools web page:      http://oss.oracle.com/projects/ocfs2-tools
+Project web page:    http://ocfs2.wiki.kernel.org
+Tools git tree:      https://github.com/markfasheh/ocfs2-tools
 OCFS2 mailing lists: http://oss.oracle.com/projects/ocfs2/mailman/
 
 All code copyright 2005 Oracle except when otherwise noted.
diff -puN MAINTAINERS~ocfs2-update-web-page-git-tree-in-documentation MAINTAINERS
--- a/MAINTAINERS~ocfs2-update-web-page-git-tree-in-documentation
+++ a/MAINTAINERS
@@ -7206,8 +7206,7 @@ ORACLE CLUSTER FILESYSTEM 2 (OCFS2)
 M:	Mark Fasheh <mfasheh@suse.com>
 M:	Joel Becker <jlbec@evilplan.org>
 L:	ocfs2-devel@oss.oracle.com (moderated for non-subscribers)
-W:	http://oss.oracle.com/projects/ocfs2/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jlbec/ocfs2.git
+W:	http://ocfs2.wiki.kernel.org
 S:	Supported
 F:	Documentation/filesystems/ocfs2.txt
 F:	Documentation/filesystems/dlmfs.txt
_

Patches currently in -mm which might be from mfasheh@suse.de are

origin.patch
ocfs2-update-web-page-git-tree-in-documentation.patch

