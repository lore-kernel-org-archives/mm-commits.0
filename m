From: akpm@linux-foundation.org
Subject: + add-myself-to-get_maintainerignore.patch added to -mm tree
Date: Mon, 17 Aug 2015 13:12:14 -0700
Message-ID: <55d2401e.2VO8e1e8NMF2+W/c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45851 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbbHQUMP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Aug 2015 16:12:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Add hch to .get_maintainer.ignore
has been added to the -mm tree.  Its filename is
     add-myself-to-get_maintainerignore.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/add-myself-to-get_maintainerignore.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/add-myself-to-get_maintainerignore.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: Add hch to .get_maintainer.ignore

While the idea behind get_maintainer seems highly useful it's
unfortunately way to trigger happy to grab people that once had a few
commits to files.  For someone like me who does a lot of tree-wide API
work that leads to an incredible amount of Cc spam.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .get_maintainer.ignore |    1 +
 1 file changed, 1 insertion(+)

diff -puN /dev/null .get_maintainer.ignore
--- /dev/null
+++ a/.get_maintainer.ignore
@@ -0,0 +1 @@
+Christoph Hellwig <hch@lst.de>
_

Patches currently in -mm which might be from hch@lst.de are

add-myself-to-get_maintainerignore.patch
mm-swap-zswap-maybe_preload-refactoring.patch
linux-next.patch

