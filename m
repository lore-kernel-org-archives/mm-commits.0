From: akpm@linux-foundation.org
Subject: + maintainers-move-the-befs-tree-to-kernelorg.patch added to -mm
 tree
Date: Thu, 13 Jul 2017 12:24:57 -0700
Message-ID: <5967c909.M0eAefKcmu2F0uul%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49326 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752545AbdGMTY6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2017 15:24:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luisbg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: move the befs tree to kernel.org
has been added to the -mm tree.  Its filename is
     maintainers-move-the-befs-tree-to-kernelorg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-move-the-befs-tree-to-kernelorg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-move-the-befs-tree-to-kernelorg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luis de Bethencourt <luisbg@kernel.org>
Subject: MAINTAINERS: move the befs tree to kernel.org

Update the location of the befs git tree and my email address.

Link: http://lkml.kernel.org/r/20170709110012.2991-1-luisbg@kernel.org
Signed-off-by: Luis de Bethencourt <luisbg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-move-the-befs-tree-to-kernelorg MAINTAINERS
--- a/MAINTAINERS~maintainers-move-the-befs-tree-to-kernelorg
+++ a/MAINTAINERS
@@ -2516,10 +2516,10 @@ S:	Supported
 F:	drivers/media/platform/sti/delta
 
 BEFS FILE SYSTEM
-M:	Luis de Bethencourt <luisbg@osg.samsung.com>
+M:	Luis de Bethencourt <luisbg@kernel.org>
 M:	Salah Triki <salah.triki@gmail.com>
 S:	Maintained
-T:	git git://github.com/luisbg/linux-befs.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/luisbg/linux-befs.git
 F:	Documentation/filesystems/befs.txt
 F:	fs/befs/
 
_

Patches currently in -mm which might be from luisbg@kernel.org are

maintainers-move-the-befs-tree-to-kernelorg.patch

