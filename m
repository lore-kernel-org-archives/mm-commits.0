From: akpm@linux-foundation.org
Subject: + maintainers-fix-arch-arm-plat-omap-include-plat-omap_hwmodh.patch added to -mm tree
Date: Thu, 10 Jan 2013 13:46:54 -0800
Message-ID: <20130110214654.9066C100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:45380 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247Ab3AJVq4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Jan 2013 16:46:56 -0500
Received: by mail-vb0-f73.google.com with SMTP id l1so136278vba.2
        for <mm-commits@vger.kernel.org>; Thu, 10 Jan 2013 13:46:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhangyanfei@cn.fujitsu.com


The patch titled
     Subject: MAINTAINERS: fix arch/arm/plat-omap/include/plat/omap_hwm=
od.h
has been added to the -mm tree.  Its filename is
     maintainers-fix-arch-arm-plat-omap-include-plat-omap_hwmodh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -5679,8 +5679,7 @@ M:	Beno=C3=AEt Cousson <b-cousson@ti.com>
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

maintainers-fix-arch-arm-plat-omap-include-plat-omap_hwmodh.patch
maintainers-fix-a-status-pattern.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
