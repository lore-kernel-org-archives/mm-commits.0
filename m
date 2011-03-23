From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-topgit-for-t.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:39:35 -0700
Message-ID: <201103232043.p2NKhBHL028840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753600Ab1CWUzC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiaweiwei.xiyou@gmail.com, harryxiyou@gmail.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: add topgit for T:
has been removed from the -mm tree.  Its filename was
     maintainers-add-topgit-for-t.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: add topgit for T:
From: Harry Wei <jiaweiwei.xiyou@gmail.com>

At least one tree:

	ARM/EZX SMARTPHONES (A780, A910, A1200, E680, ROKR E2 and ROKR E6)

is available via topgit.  Add mention of topgit in the MAINTAINERS
description section.

Signed-off-by: Harry Wei <harryxiyou@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-add-topgit-for-t MAINTAINERS
--- a/MAINTAINERS~maintainers-add-topgit-for-t
+++ a/MAINTAINERS
@@ -72,7 +72,7 @@ Descriptions of section entries:
 	L: Mailing list that is relevant to this area
 	W: Web-page with status/info
 	Q: Patchwork web based patch tracking system site
-	T: SCM tree type and location.  Type is one of: git, hg, quilt, stgit.
+	T: SCM tree type and location.  Type is one of: git, hg, quilt, stgit, topgit.
 	S: Status, one of the following:
 	   Supported:	Someone is actually paid to look after this.
 	   Maintained:	Someone actually looks after it.
_

Patches currently in -mm which might be from jiaweiwei.xiyou@gmail.com are

origin.patch

