From: akpm@linux-foundation.org
Subject: + maintainers-remove-linux-listsopenriscnet.patch added to -mm
 tree
Date: Thu, 24 Mar 2016 15:18:21 -0700
Message-ID: <56f467ad.5UtDsKV2iNfz2yJ3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41875 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbcCXWSX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2016 18:18:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, jonas@southpole.se, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove linux@lists.openrisc.net
has been added to the -mm tree.  Its filename is
     maintainers-remove-linux-listsopenriscnet.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-remove-linux-listsopenriscnet.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-remove-linux-listsopenriscnet.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -8159,7 +8159,6 @@ F:	drivers/of/resolver.c
 OPENRISC ARCHITECTURE
 M:	Jonas Bonn <jonas@southpole.se>
 W:	http://openrisc.net
-L:	linux@lists.openrisc.net (moderated for non-subscribers)
 S:	Maintained
 T:	git git://openrisc.net/~jonas/linux
 F:	arch/openrisc/
_

Patches currently in -mm which might be from jslaby@suse.cz are

maintainers-remove-linux-listsopenriscnet.patch

