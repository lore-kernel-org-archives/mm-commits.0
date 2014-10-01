From: akpm@linux-foundation.org
Subject: + maintainers-change-git-url-for-mpc5xxx-tree.patch added to -mm
 tree
Date: Wed, 01 Oct 2014 13:27:56 -0700
Message-ID: <542c63cc.8MTlHdCfqWJcZy8b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaJAU14 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 16:27:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: agust@denx.de, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: change git URL for mpc5xxx tree
has been added to the -mm tree.  Its filename is
     maintainers-change-git-url-for-mpc5xxx-tree.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-change-git-url-for-mpc5xxx-tree.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-change-git-url-for-mpc5xxx-tree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anatolij Gustschin <agust@denx.de>
Subject: MAINTAINERS: change git URL for mpc5xxx tree

The repository for mpc5xxx has been moved, update git URL to new location.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-change-git-url-for-mpc5xxx-tree MAINTAINERS
--- a/MAINTAINERS~maintainers-change-git-url-for-mpc5xxx-tree
+++ a/MAINTAINERS
@@ -5478,7 +5478,7 @@ F:	drivers/macintosh/
 LINUX FOR POWERPC EMBEDDED MPC5XXX
 M:	Anatolij Gustschin <agust@denx.de>
 L:	linuxppc-dev@lists.ozlabs.org
-T:	git git://git.denx.de/linux-2.6-agust.git
+T:	git git://git.denx.de/linux-denx-agust.git
 S:	Maintained
 F:	arch/powerpc/platforms/512x/
 F:	arch/powerpc/platforms/52xx/
_

Patches currently in -mm which might be from agust@denx.de are

maintainers-change-git-url-for-mpc5xxx-tree.patch

