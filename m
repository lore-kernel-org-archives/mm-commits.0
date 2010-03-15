From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-bfin_sdh-driver.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:52:45 -0400
Message-ID: <201003150653.o2F6rIm2015986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58615 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756997Ab0COGxV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:53:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: add bfin_sdh driver
has been removed from the -mm tree.  Its filename was
     maintainers-add-bfin_sdh-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: add bfin_sdh driver
From: Mike Frysinger <vapier@gentoo.org>

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN MAINTAINERS~maintainers-add-bfin_sdh-driver MAINTAINERS
--- a/MAINTAINERS~maintainers-add-bfin_sdh-driver
+++ a/MAINTAINERS
@@ -1235,6 +1235,13 @@ W:	http://blackfin.uclinux.org
 S:	Supported
 F:	drivers/rtc/rtc-bfin.c
 
+BLACKFIN SDH DRIVER
+M:	Cliff Cai <cliff.cai@analog.com>
+L:	uclinux-dist-devel@blackfin.uclinux.org
+W:	http://blackfin.uclinux.org
+S:	Supported
+F:	drivers/mmc/host/bfin_sdh.c
+
 BLACKFIN SERIAL DRIVER
 M:	Sonic Zhang <sonic.zhang@analog.com>
 L:	uclinux-dist-devel@blackfin.uclinux.org
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch

