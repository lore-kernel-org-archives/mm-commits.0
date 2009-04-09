From: akpm@linux-foundation.org
Subject: + maintainers-switch-maintainer-of-the-hso-driver.patch added to -mm tree
Date: Thu, 09 Apr 2009 12:16:44 -0700
Message-ID: <200904091916.n39JGia2011462@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43182 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935840AbZDITUG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 15:20:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: j.dumon@option.com, davem@davemloft.net, greg@kroah.com


The patch titled
     MAINTAINERS: switch maintainer of the hso driver
has been added to the -mm tree.  Its filename is
     maintainers-switch-maintainer-of-the-hso-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: switch maintainer of the hso driver
From: Jan Dumon <j.dumon@option.com>

Since Denis is no longer working for Option, I will maintain the driver from
now on.

Signed-off-by: Jan Dumon <j.dumon@option.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-switch-maintainer-of-the-hso-driver MAINTAINERS
--- a/MAINTAINERS~maintainers-switch-maintainer-of-the-hso-driver
+++ a/MAINTAINERS
@@ -2134,8 +2134,8 @@ W:	http://artax.karlin.mff.cuni.cz/~miku
 S:	Maintained
 
 HSO	3G Modem Driver (hso.c)
-P:	Denis Joseph Barrow
-M:	d.barow@option.com
+P:	Jan Dumon
+M:	j.dumon@option.com
 W:	http://www.pharscape.org
 S:	Maintained
 
_

Patches currently in -mm which might be from j.dumon@option.com are

maintainers-switch-maintainer-of-the-hso-driver.patch

