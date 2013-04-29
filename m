From: akpm@linux-foundation.org
Subject: [folded-merged] get_maintainer-use-filename-only-regex-match-for-tegra-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 16:00:33 -0700
Message-ID: <20130429230034.32E735A418D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:41146 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757577Ab3D2XAf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 19:00:35 -0400
Received: by mail-qe0-f74.google.com with SMTP id a11so153515qen.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 16:00:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, marcin.slusarz@gmail.com, swarren@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer-use-filename-only-regex-match-for-tegra-fix
has been removed from the -mm tree.  Its filename was
     get_maintainer-use-filename-only-regex-match-for-tegra-fix.patch

This patch was dropped because it was folded into get_maintainer-use-filename-only-regex-match-for-tegra.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: get_maintainer-use-filename-only-regex-match-for-tegra-fix

fix typo in docs, per Marcin

Cc: Joe Perches <joe@perches.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~get_maintainer-use-filename-only-regex-match-for-tegra-fix MAINTAINERS
--- a/MAINTAINERS~get_maintainer-use-filename-only-regex-match-for-tegra-fix
+++ a/MAINTAINERS
@@ -91,7 +91,7 @@ Descriptions of section entries:
 	   F:	*/net/*		all files in "any top level directory"/net
 	   One pattern per line.  Multiple F: lines acceptable.
 	N: Files and directories with regex patterns.
-	   N:	[^a-z]tegra	all files whose patch contains the word tegra
+	   N:	[^a-z]tegra	all files whose path contains the word tegra
 	   One pattern per line.  Multiple N: lines acceptable.
 	X: Files and directories that are NOT maintained, same rules as F:
 	   Files exclusions are tested before file matches.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are


