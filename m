From: akpm@linux-foundation.org
Subject: + maintainers-add-git-trees-for-spi-and-device-tree.patch added to -mm tree
Date: Thu, 10 Jun 2010 13:38:38 -0700
Message-ID: <201006102038.o5AKccot022488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754860Ab0FJUi4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jun 2010 16:38:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: grant.likely@secretlab.ca


The patch titled
     maintainers: add git trees for SPI and device tree
has been added to the -mm tree.  Its filename is
     maintainers-add-git-trees-for-spi-and-device-tree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: maintainers: add git trees for SPI and device tree
From: Grant Likely <grant.likely@secretlab.ca>

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

diff -puN MAINTAINERS~maintainers-add-git-trees-for-spi-and-device-tree MAINTAINERS
--- a/MAINTAINERS~maintainers-add-git-trees-for-spi-and-device-tree
+++ a/MAINTAINERS
@@ -4221,6 +4221,7 @@ OPEN FIRMWARE AND FLATTENED DEVICE TREE
 M:	Grant Likely <grant.likely@secretlab.ca>
 L:	devicetree-discuss@lists.ozlabs.org
 W:	http://fdt.secretlab.ca
+T:	git git://git.secretlab.ca/git/linux-2.6.git
 S:	Maintained
 F:	drivers/of
 F:	include/linux/of*.h
@@ -5399,6 +5400,7 @@ M:	David Brownell <dbrownell@users.sourc
 M:	Grant Likely <grant.likely@secretlab.ca>
 L:	spi-devel-general@lists.sourceforge.net
 Q:	http://patchwork.kernel.org/project/spi-devel-general/list/
+T:	git git://git.secretlab.ca/git/linux-2.6.git
 S:	Maintained
 F:	Documentation/spi/
 F:	drivers/spi/
_

Patches currently in -mm which might be from grant.likely@secretlab.ca are

linux-next.patch
maintainers-add-git-trees-for-spi-and-device-tree.patch

