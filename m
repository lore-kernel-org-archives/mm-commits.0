From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-m68knommu-patterns.patch removed from -mm tree
Date: Mon, 18 Apr 2011 11:02:42 -0700
Message-ID: <201104181758.p3IHwr9D016093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756173Ab1DRR73 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Apr 2011 13:59:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: update m68knommu patterns
has been removed from the -mm tree.  Its filename was
     maintainers-update-m68knommu-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -6255,7 +6255,8 @@ M:	Greg Ungerer <gerg@uclinux.org>
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
linux-next.patch
checkpatch-add-check-for-line-continuations-in-quoted-strings.patch

