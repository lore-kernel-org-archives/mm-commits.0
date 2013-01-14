From: akpm@linux-foundation.org
Subject: [merged] maintainers-fix-arch-arm-plat-omap-include-plat-omap_hwmodh.patch removed from -mm tree
Date: Mon, 14 Jan 2013 12:38:55 -0800
Message-ID: <20130114203855.958D382004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:46377 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757312Ab3ANUi4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jan 2013 15:38:56 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so294426qaq.5
        for <mm-commits@vger.kernel.org>; Mon, 14 Jan 2013 12:38:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: fix arch/arm/plat-omap/include/plat/omap_hwm=
od.h
has been removed from the -mm tree.  Its filename was
     maintainers-fix-arch-arm-plat-omap-include-plat-omap_hwmodh.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: MAINTAINERS: fix arch/arm/plat-omap/include/plat/omap_hwmod.h

This file was moved to arch/arm/mach-omap2/omap=3D5Fhwmod.h by 2a296c8
("ARM: OMAP: Make plat/omap=3D5Fhwmod.h local to mach-omap2").

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-fix-arch-arm-plat-omap-include-plat-o=
map_hwmodh MAINTAINERS
--- a/MAINTAINERS~maintainers-fix-arch-arm-plat-omap-include-plat-omap_=
hwmodh
+++ a/MAINTAINERS
@@ -5507,8 +5507,7 @@ M:	Beno=C3=AEt Cousson <b-cousson@ti.com>
 M:	Paul Walmsley <paul@pwsan.com>
 L:	linux-omap@vger.kernel.org
 S:	Maintained
-F:	arch/arm/mach-omap2/omap_hwmod.c
-F:	arch/arm/plat-omap/include/plat/omap_hwmod.h
+F:	arch/arm/mach-omap2/omap_hwmod.*
=20
 OMAP HWMOD DATA FOR OMAP4-BASED DEVICES
 M:	Beno=C3=AEt Cousson <b-cousson@ti.com>
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com=
 are

origin.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
