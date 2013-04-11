From: akpm@linux-foundation.org
Subject: + maintainers-petko-has-moved.patch added to -mm tree
Date: Thu, 11 Apr 2013 14:03:39 -0700
Message-ID: <20130411210339.67F7C5A40E5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:55158 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab3DKVDk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 17:03:40 -0400
Received: by mail-ve0-f201.google.com with SMTP id ox1so186273veb.0
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 14:03:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: petkan@nucleusys.com


The patch titled
     Subject: MAINTAINERS: Petko has moved
has been added to the -mm tree.  Its filename is
     maintainers-petko-has-moved.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Petko Manolov <petkan@nucleusys.com>
Subject: MAINTAINERS: Petko has moved

Signed-off-by: Petko Manolov <petkan@nucleusys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers MAINTAINERS
--- a/MAINTAINERS~maintainers
+++ a/MAINTAINERS
@@ -8443,9 +8443,10 @@ S:	Maintained
 F:	drivers/usb/serial/option.c
 
 USB PEGASUS DRIVER
-M:	Petko Manolov <petkan@users.sourceforge.net>
+M:	Petko Manolov <petkan@nucleusys.com>
 L:	linux-usb@vger.kernel.org
 L:	netdev@vger.kernel.org
+T:	git git://git.code.sf.net/p/pegasus2/git
 W:	http://pegasus2.sourceforge.net/
 S:	Maintained
 F:	drivers/net/usb/pegasus.*
@@ -8465,9 +8466,10 @@ S:	Supported
 F:	drivers/usb/class/usblp.c
 
 USB RTL8150 DRIVER
-M:	Petko Manolov <petkan@users.sourceforge.net>
+M:	Petko Manolov <petkan@nucleusys.com>
 L:	linux-usb@vger.kernel.org
 L:	netdev@vger.kernel.org
+T:	git git://git.code.sf.net/p/pegasus2/git
 W:	http://pegasus2.sourceforge.net/
 S:	Maintained
 F:	drivers/net/usb/rtl8150.c
_

Patches currently in -mm which might be from petkan@nucleusys.com are

maintainers-petko-has-moved.patch

