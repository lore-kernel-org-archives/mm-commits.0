From: akpm@linux-foundation.org
Subject: [merged] maintainers-fix-drivers-ieee802154.patch removed from -mm tree
Date: Mon, 07 Jan 2013 11:26:26 -0800
Message-ID: <20130107192626.8FC72100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:37252 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab3AGT01 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:26:27 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so1802643ghb.0
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:26:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: fix drivers/ieee802154/
has been removed from the -mm tree.  Its filename was
     maintainers-fix-drivers-ieee802154.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: MAINTAINERS: fix drivers/ieee802154/

This directory was moved to drivers/net/ieee802154/ by commit 31d178b
("drivers/ieee802154: move ieee802154 drivers to net folder").

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-fix-drivers-ieee802154 MAINTAINERS
--- a/MAINTAINERS~maintainers-fix-drivers-ieee802154
+++ a/MAINTAINERS
@@ -3878,7 +3878,7 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Maintained
 F:	net/ieee802154/
 F:	net/mac802154/
-F:	drivers/ieee802154/
+F:	drivers/net/ieee802154/
 
 IGUANAWORKS USB IR TRANSCEIVER
 M:	Sean Young <sean@mess.org>
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch
linux-next.patch

