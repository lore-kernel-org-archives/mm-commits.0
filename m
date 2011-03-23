From: akpm@linux-foundation.org
Subject: [merged] maintainers-usb-se401-moved-to-staging-update-pattern.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:40:04 -0700
Message-ID: <201103232043.p2NKheUf028978@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42709 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933468Ab1CWUo0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:44:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, hverkuil@xs4all.nl, mchehab@redhat.com, pe1rxq@amsat.org, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: uSB SE401 moved to staging, update pattern
has been removed from the -mm tree.  Its filename was
     maintainers-usb-se401-moved-to-staging-update-pattern.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: uSB SE401 moved to staging, update pattern
From: Joe Perches <joe@perches.com>

And set the status to Orphan.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jeroen Vreeken <pe1rxq@amsat.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-usb-se401-moved-to-staging-update-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-usb-se401-moved-to-staging-update-pattern
+++ a/MAINTAINERS
@@ -6465,12 +6465,11 @@ S:	Maintained
 F:	drivers/net/usb/rtl8150.c
 
 USB SE401 DRIVER
-M:	Jeroen Vreeken <pe1rxq@amsat.org>
 L:	linux-usb@vger.kernel.org
 W:	http://www.chello.nl/~j.vreeken/se401/
-S:	Maintained
+S:	Orphan
 F:	Documentation/video4linux/se401.txt
-F:	drivers/media/video/se401.*
+F:	drivers/staging/se401/
 
 USB SERIAL BELKIN F5U103 DRIVER
 M:	William Greathouse <wgreathouse@smva.com>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch

