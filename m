From: akpm@linux-foundation.org
Subject: + maintainers-networking-drivers-matches-too-much.patch added to -mm tree
Date: Thu, 18 Oct 2012 12:48:06 -0700
Message-ID: <20121018194806.A26B6100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:43308 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab2JRTsI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Oct 2012 15:48:08 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so1128759yhl.1
        for <mm-commits@vger.kernel.org>; Thu, 18 Oct 2012 12:48:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdelvare@nerim.net, davem@davemloft.net, joe@perches.com, khali@linux-fr.org


The patch titled
     Subject: MAINTAINERS: NETWORKING DRIVERS matches too much
has been added to the -mm tree.  Its filename is
     maintainers-networking-drivers-matches-too-much.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jean Delvare <jdelvare@nerim.net>
Subject: MAINTAINERS: NETWORKING DRIVERS matches too much

File pattern include/linux/*device.h matches too much, including
completely unrelated files.  If some of these files should really be
listed, please list them explicitly.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Joe Perches <joe@perches.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-networking-drivers-matches-too-much MAINTAINERS
--- a/MAINTAINERS~maintainers-networking-drivers-matches-too-much
+++ a/MAINTAINERS
@@ -5067,7 +5067,6 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Odd Fixes
 F:	drivers/net/
 F:	include/linux/if_*
-F:	include/linux/*device.h
 
 NETXEN (1/10) GbE SUPPORT
 M:	Sony Chacko <sony.chacko@qlogic.com>
_

Patches currently in -mm which might be from jdelvare@nerim.net are

maintainers-networking-drivers-matches-too-much.patch

