From: akpm@linux-foundation.org
Subject: [patch 085/162] MAINTAINERS: remove linux@lists.openrisc.net
Date: Fri, 20 May 2016 17:00:46 -0700
Message-ID: <573fa52e.32/U5wappiRvG8J4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52758 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbcEUAAr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:00:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jslaby@suse.cz, jonas@southpole.se

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
