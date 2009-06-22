From: akpm@linux-foundation.org
Subject: [merged] maintainers-fix-atheros-pattern-paths.patch removed from -mm tree
Date: Mon, 22 Jun 2009 10:00:48 -0700
Message-ID: <200906221700.n5MH0mA2010196@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752871AbZFVRCN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jun 2009 13:02:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, jirislaby@gmail.com, lrodriguez@atheros.com, me@bobcopeland.com, mickflemm@gmail.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: fix Atheros pattern paths
has been removed from the -mm tree.  Its filename was
     maintainers-fix-atheros-pattern-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: fix Atheros pattern paths
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Bob Copeland <me@bobcopeland.com>
Cc: "Luis R . Rodriguez" <lrodriguez@atheros.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-fix-atheros-pattern-paths MAINTAINERS
--- a/MAINTAINERS~maintainers-fix-atheros-pattern-paths
+++ a/MAINTAINERS
@@ -946,7 +946,7 @@ M:	me@bobcopeland.com
 L:	linux-wireless@vger.kernel.org
 L:	ath5k-devel@lists.ath5k.org
 S:	Maintained
-F:	drivers/net/wireless/ath5k/
+F:	drivers/net/wireless/ath/ath5k/
 
 ATHEROS ATH9K WIRELESS DRIVER
 P:	Luis R. Rodriguez
@@ -962,7 +962,7 @@ M:	senthilkumar@atheros.com
 L:	linux-wireless@vger.kernel.org
 L:	ath9k-devel@lists.ath9k.org
 S:	Supported
-F:	drivers/net/wireless/ath9k/
+F:	drivers/net/wireless/ath/ath9k/
 
 ATHEROS AR9170 WIRELESS DRIVER
 P:	Christian Lamparter
@@ -970,7 +970,7 @@ M:	chunkeey@web.de
 L:	linux-wireless@vger.kernel.org
 W:	http://wireless.kernel.org/en/users/Drivers/ar9170
 S:	Maintained
-F:	drivers/net/wireless/ar9170/
+F:	drivers/net/wireless/ath/ar9170/
 
 ATI_REMOTE2 DRIVER
 P:	Ville Syrjala
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch

