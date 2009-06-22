From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-wirelessh-path.patch removed from -mm tree
Date: Mon, 22 Jun 2009 10:00:52 -0700
Message-ID: <200906221700.n5MH0qsQ010211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52174 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753330AbZFVRK1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jun 2009 13:10:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: update wireless.h path
has been removed from the -mm tree.  Its filename was
     maintainers-update-wirelessh-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: update wireless.h path
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-wirelessh-path MAINTAINERS
--- a/MAINTAINERS~maintainers-update-wirelessh-path
+++ a/MAINTAINERS
@@ -4083,7 +4083,7 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Maintained
 F:	net/wireless/
 F:	include/net/ieee80211*
-F:	include/net/wireless.h
+F:	include/linux/wireless.h
 
 NETWORKING DRIVERS
 L:	netdev@vger.kernel.org
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch

