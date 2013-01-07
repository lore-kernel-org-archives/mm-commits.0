From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-drivers-video-epson1355fbc.patch removed from -mm tree
Date: Mon, 07 Jan 2013 11:26:19 -0800
Message-ID: <20130107192619.A59C182005F@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:52347 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330Ab3AGT0U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:26:20 -0500
Received: by mail-gg0-f201.google.com with SMTP id o6so2114043ggm.0
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:26:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, ch@hpl.hp.com, ch@murgatroid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove drivers/video/epson1355fb.c
has been removed from the -mm tree.  Its filename was
     maintainers-remove-drivers-video-epson1355fbc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: MAINTAINERS: remove drivers/video/epson1355fb.c

This driver was removed by commit 1c3a918 ("ARM: clps711x: Remove board
support for CEIVA").

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Christopher Hoover <ch@murgatroid.com>
Cc: Christopher Hoover <ch@hpl.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ------
 1 file changed, 6 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-drivers-video-epson1355fbc MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-drivers-video-epson1355fbc
+++ a/MAINTAINERS
@@ -2944,12 +2944,6 @@ M:	Maxim Levitsky <maximlevitsky@gmail.c
 S:	Maintained
 F:	drivers/media/rc/ene_ir.*
 
-EPSON 1355 FRAMEBUFFER DRIVER
-M:	Christopher Hoover <ch@murgatroid.com>
-M:	Christopher Hoover <ch@hpl.hp.com>
-S:	Maintained
-F:	drivers/video/epson1355fb.c
