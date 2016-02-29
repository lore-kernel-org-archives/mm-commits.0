From: akpm@linux-foundation.org
Subject: + maintainers-update-s-par-driver-maintainer-list.patch added to
 -mm tree
Date: Mon, 29 Feb 2016 15:36:23 -0800
Message-ID: <56d4d5f7.eXAF43c6GnCwR2GV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47916 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbcB2XgY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Feb 2016 18:36:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david.kershner@unisys.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update s-Par driver maintainer list
has been added to the -mm tree.  Its filename is
     maintainers-update-s-par-driver-maintainer-list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-s-par-driver-maintainer-list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-s-par-driver-maintainer-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Kershner <david.kershner@unisys.com>
Subject: MAINTAINERS: update s-Par driver maintainer list

Benjamin Romer is no longer a maintainer for the Unisys s-Par driver,
presently in drivers/staging/unisys/.

Signed-off-by: David Kershner <david.kershner@unisys.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-s-par-driver-maintainer-list MAINTAINERS
--- a/MAINTAINERS~maintainers-update-s-par-driver-maintainer-list
+++ a/MAINTAINERS
@@ -11231,7 +11231,6 @@ F:	include/linux/cdrom.h
 F:	include/uapi/linux/cdrom.h
 
 UNISYS S-PAR DRIVERS
-M:	Benjamin Romer <benjamin.romer@unisys.com>
 M:	David Kershner <david.kershner@unisys.com>
 L:	sparmaintainer@unisys.com (Unisys internal)
 S:	Supported
_

Patches currently in -mm which might be from david.kershner@unisys.com are

maintainers-update-s-par-driver-maintainer-list.patch

