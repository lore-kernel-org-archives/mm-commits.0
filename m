From: akpm@linux-foundation.org
Subject: + maintainers-update-m68knommu-patterns.patch added to -mm tree
Date: Wed, 30 Mar 2011 15:36:31 -0700
Message-ID: <201103302236.p2UMaVwt016308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56005 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753491Ab1C3WhI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Mar 2011 18:37:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, gerg@uclinux.org


The patch titled
     MAINTAINERS: update m68knommu patterns
has been added to the -mm tree.  Its filename is
     maintainers-update-m68knommu-patterns.patch

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
Subject: MAINTAINERS: update m68knommu patterns
From: Joe Perches <joe@perches.com>

Commit 66d857b08b ("m68k: merge m68k and m68knommu arch directories")
moved the files around.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-m68knommu-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-update-m68knommu-patterns
+++ a/MAINTAINERS
@@ -6267,7 +6267,8 @@ M:	Greg Ungerer <gerg@uclinux.org>
 W:	http://www.uclinux.org/
 L:	uclinux-dev@uclinux.org  (subscribers-only)
 S:	Maintained
-F:	arch/m68knommu/
+F:	arch/m68k/*/*_no.*
+F:	arch/m68k/include/asm/*_no.*
 
 UCLINUX FOR RENESAS H8/300 (H8300)
 M:	Yoshinori Sato <ysato@users.sourceforge.jp>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
maintainers-update-m68knommu-patterns.patch
maintainers-update-various-tty-patterns.patch
maintainers-add-k-pattern-for-trivial-patches.patch

