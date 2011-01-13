From: akpm@linux-foundation.org
Subject: [merged] maintainers-orphan-the-meye-driver.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:06:05 -0800
Message-ID: <201101132008.p0DK8koE029936@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39102 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933670Ab1AMUJT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:09:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stelian@popies.net, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: orphan the meye driver
has been removed from the -mm tree.  Its filename was
     maintainers-orphan-the-meye-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: orphan the meye driver
From: Stelian Pop <stelian@popies.net>

I don't even remember when it was that I sold this laptop, but
it has been a few years...

Signed-off-by: Stelian Pop <stelian@popies.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-orphan-the-meye-driver MAINTAINERS
--- a/MAINTAINERS~maintainers-orphan-the-meye-driver
+++ a/MAINTAINERS
@@ -4093,9 +4093,8 @@ F:	include/linux/module.h
 F:	kernel/module.c
 
 MOTION EYE VAIO PICTUREBOOK CAMERA DRIVER
-M:	Stelian Pop <stelian@popies.net>
 W:	http://popies.net/meye/
-S:	Maintained
+S:	Orphan
 F:	Documentation/video4linux/meye.txt
 F:	drivers/media/video/meye.*
 F:	include/linux/meye.h
_

Patches currently in -mm which might be from stelian@popies.net are

origin.patch

