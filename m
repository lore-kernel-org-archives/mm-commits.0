From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-file-patterns-to-the-rest.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:38:27 -0700
Message-ID: <200906171838.n5HIcR4k004467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759432AbZFQSqL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:46:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: add file patterns to "THE REST"
has been removed from the -mm tree.  Its filename was
     maintainers-add-file-patterns-to-the-rest.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: add file patterns to "THE REST"
From: Joe Perches <joe@perches.com>

These file patterns match all sources.
By default, scripts/get_maintainers.pl excludes Linus Torvalds
from the CC: list.  Option --git-chief-penguins will include him.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN MAINTAINERS~maintainers-add-file-patterns-to-the-rest MAINTAINERS
--- a/MAINTAINERS~maintainers-add-file-patterns-to-the-rest
+++ a/MAINTAINERS
@@ -6531,5 +6531,10 @@ F:	drivers/serial/zs.*
 
 THE REST
 P:	Linus Torvalds
+M:	torvalds@linux-foundation.org
+L:	linux-kernel@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
 S:	Buried alive in reporters
+F:	*
+F:	*/
+
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-fbdev-is-orphaned.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch

