From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-status-to-alpha-architecture.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:28:44 -0700
Message-ID: <20120326192844.5C4E3A0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:55374 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab2CZT2p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:28:45 -0400
Received: by mail-bk0-f74.google.com with SMTP id jm19so288130bkc.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:28:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add status to ALPHA architecture
has been removed from the -mm tree.  Its filename was
     maintainers-add-status-to-alpha-architecture.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: add status to ALPHA architecture

Add missing S: status line to ALPHA.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-status-to-alpha-architecture MAINTAINERS
--- a/MAINTAINERS~maintainers-add-status-to-alpha-architecture
+++ a/MAINTAINERS
@@ -464,6 +464,7 @@ ALPHA PORT
 M:	Richard Henderson <rth@twiddle.net>
 M:	Ivan Kokshaysky <ink@jurassic.park.msu.ru>
 M:	Matt Turner <mattst88@gmail.com>
+S:	Odd Fixes
 L:	linux-alpha@vger.kernel.org
 F:	arch/alpha/
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-fix-remoteproc-f-typo.patch
checkpatch-suggest-pr_level-over-printkkern_level.patch

