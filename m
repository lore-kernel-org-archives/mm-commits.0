From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-linux-listsopenriscnet.patch removed
 from -mm tree
Date: Mon, 23 May 2016 12:48:37 -0700
Message-ID: <57435e95.4je9lfE+bSuGoMRS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37800 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436AbcEWTsi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:48:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, jonas@southpole.se, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove linux@lists.openrisc.net
has been removed from the -mm tree.  Its filename was
     maintainers-remove-linux-listsopenriscnet.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiri Slaby <jslaby@suse.cz>
Subject: MAINTAINERS: remove linux@lists.openrisc.net

$ host -t mx lists.openrisc.net
Host lists.openrisc.net not found: 3(NXDOMAIN)

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jonas Bonn <jonas@southpole.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-linux-listsopenriscnet MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-linux-listsopenriscnet
+++ a/MAINTAINERS
@@ -8258,7 +8258,6 @@ F:	drivers/of/resolver.c
 OPENRISC ARCHITECTURE
 M:	Jonas Bonn <jonas@southpole.se>
 W:	http://openrisc.net
-L:	linux@lists.openrisc.net (moderated for non-subscribers)
 S:	Maintained
 T:	git git://openrisc.net/~jonas/linux
 F:	arch/openrisc/
_

Patches currently in -mm which might be from jslaby@suse.cz are

maintainers-remove-koichi-yasutake.patch
kgdb-depends-on-vt.patch

