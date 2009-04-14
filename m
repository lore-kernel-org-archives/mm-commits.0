From: akpm@linux-foundation.org
Subject: [merged] maintainers-switch-maintainer-of-the-hso-driver.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:48:24 -0700
Message-ID: <200904141948.n3EJmOrC019026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55504 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752611AbZDNTvG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:51:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: j.dumon@option.com, davem@davemloft.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: switch maintainer of the hso driver
has been removed from the -mm tree.  Its filename was
     maintainers-switch-maintainer-of-the-hso-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2592,8 +2592,8 @@ S:	Maintained
 F:	fs/hpfs/
 
 HSO 3G MODEM DRIVER
-P:	Denis Joseph Barrow
-M:	d.barow@option.com
+P:	Jan Dumon
+M:	j.dumon@option.com
 W:	http://www.pharscape.org
 S:	Maintained
 F:	drivers/net/usb/hso.c
_

Patches currently in -mm which might be from j.dumon@option.com are

origin.patch

