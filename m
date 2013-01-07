From: akpm@linux-foundation.org
Subject: [merged] maintainers-fix-drivers-staging-sm7xx.patch removed from -mm tree
Date: Mon, 07 Jan 2013 11:26:50 -0800
Message-ID: <20130107192650.8FAFD100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:58100 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab3AGT0v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:26:51 -0500
Received: by mail-yh0-f74.google.com with SMTP id w68so1067303yhw.1
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:26:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, jmunhoz@igalia.com, teddy.wang@siliconmotion.com.cn, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: fix drivers/staging/sm7xx/
has been removed from the -mm tree.  Its filename was
     maintainers-fix-drivers-staging-sm7xx.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: MAINTAINERS: fix drivers/staging/sm7xx/

This directory was moved to drivers/staging/sm7xxfb/ by commit 925aa66
("staging: sm7xxfb: sm7xx becomes sm7xxfb").

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Teddy Wang <teddy.wang@siliconmotion.com.cn>
Acked-by: Javier Mu=F1oz <jmunhoz@igalia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-fix-drivers-staging-sm7xx MAINTAINERS
--- a/MAINTAINERS~maintainers-fix-drivers-staging-sm7xx
+++ a/MAINTAINERS
@@ -7316,7 +7316,7 @@ F:	drivers/staging/rtl8712/
 STAGING - SILICON MOTION SM7XX FRAME BUFFER DRIVER
 M:	Teddy Wang <teddy.wang@siliconmotion.com.cn>
 S:	Odd Fixes
-F:	drivers/staging/sm7xx/
+F:	drivers/staging/sm7xxfb/
=20
 STAGING - SOFTLOGIC 6x10 MPEG CODEC
 M:	Ben Collins <bcollins@bluecherry.net>
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
