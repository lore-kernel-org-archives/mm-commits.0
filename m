From: akpm@linux-foundation.org
Subject: [to-be-updated] maintainers-networking-drivers-matches-too-much.patch removed from -mm tree
Date: Thu, 18 Oct 2012 13:25:08 -0700
Message-ID: <20121018202509.4A747100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:45286 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab2JRUZK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Oct 2012 16:25:10 -0400
Received: by mail-vb0-f74.google.com with SMTP id s24so1035533vbi.1
        for <mm-commits@vger.kernel.org>; Thu, 18 Oct 2012 13:25:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdelvare@nerim.net, davem@davemloft.net, joe@perches.com, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: NETWORKING DRIVERS matches too much
has been removed from the -mm tree.  Its filename was
     maintainers-networking-drivers-matches-too-much.patch

This patch was dropped because an updated version will be merged

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


