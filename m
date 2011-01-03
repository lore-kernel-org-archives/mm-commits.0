From: akpm@linux-foundation.org
Subject: + maintainers-orphan-the-meye-driver.patch added to -mm tree
Date: Mon, 03 Jan 2011 11:27:52 -0800
Message-ID: <201101031927.p03JRqkI024460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751940Ab1ACT2O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jan 2011 14:28:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stelian@popies.net


The patch titled
     MAINTAINERS: orphan the meye driver
has been added to the -mm tree.  Its filename is
     maintainers-orphan-the-meye-driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -4025,9 +4025,8 @@ F:	include/linux/module.h
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

credits-update-stelians-entry.patch
maintainers-orphan-the-meye-driver.patch
maintainers-remove-stelian-from-the-ams-driver-record.patch

