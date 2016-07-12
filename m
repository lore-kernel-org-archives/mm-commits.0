From: akpm@linux-foundation.org
Subject: [obsolete]
 maintainers-remove-unreachable-people-that-have-left-atmel.patch removed
 from -mm tree
Date: Tue, 12 Jul 2016 12:58:21 -0700
Message-ID: <57854bdd.JiwJD4h9Iih1FuFm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbcGLT6W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Jul 2016 15:58:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: luisbg@osg.samsung.com, davem@davemloft.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove unreachable people that have left Atmel
has been removed from the -mm tree.  Its filename was
     maintainers-remove-unreachable-people-that-have-left-atmel.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: MAINTAINERS: remove unreachable people that have left Atmel

When sending an email regarding a patch to wilc1000, you get the following
automatic replies:
"Sung_hoon Cho is no longer with Atmel Corporation."
"Kang_hee Park is no longer with Atmel Corporation."
"Dong_ho Shin is no longer with Atmel Corporation."
"Bo_moon Kim is no longer with Atmel Corporation."
"Min_su Kim is no longer with Atmel Corporation."
"Jun_hyuk Lee is no longer with Atmel Corporation."

Removing this entry since none of the maintainers are reachable.

Link: http://lkml.kernel.org/r/1467033373-20967-1-git-send-email-luisbg@osg.samsung.com
Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
Cc: Greg KH <greg@kroah.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-unreachable-people-that-have-left-atmel MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-unreachable-people-that-have-left-atmel
+++ a/MAINTAINERS
@@ -11131,17 +11131,6 @@ M:	Forest Bond <forest@alittletooquiet.n
 S:	Odd Fixes
 F:	drivers/staging/vt665?/
 
-STAGING - WILC1000 WIFI DRIVER
-M:	Johnny Kim <johnny.kim@atmel.com>
-M:	Austin Shin <austin.shin@atmel.com>
-M:	Chris Park <chris.park@atmel.com>
-M:	Tony Cho <tony.cho@atmel.com>
-M:	Glen Lee <glen.lee@atmel.com>
-M:	Leo Kim <leo.kim@atmel.com>
-L:	linux-wireless@vger.kernel.org
-S:	Supported
-F:	drivers/staging/wilc1000/
