From: akpm@linux-foundation.org
Subject: + maintainers-add-maintainer-for-led-subsystem.patch added to -mm tree
Date: Thu, 10 May 2012 11:20:56 -0700
Message-ID: <20120510182057.A7437A0363@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:42479 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760637Ab2EJSVB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 May 2012 14:21:01 -0400
Received: by eeit10 with SMTP id t10so96961eei.1
        for <mm-commits@vger.kernel.org>; Thu, 10 May 2012 11:21:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bryan.wu@canonical.com, arnd@arndb.de, richard.purdie@linuxfoundation.org


The patch titled
     Subject: MAINTAINERS: add maintainer for LED subsystem
has been added to the -mm tree.  Its filename is
     maintainers-add-maintainer-for-led-subsystem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bryan Wu <bryan.wu@canonical.com>
Subject: MAINTAINERS: add maintainer for LED subsystem

Add Bryan Wu as the primary maintainer for drivers/leds

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
Acked-by: Richard Purdie <richard.purdie@linuxfoundation.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-maintainer-for-led-subsystem MAINTAINERS
--- a/MAINTAINERS~maintainers-add-maintainer-for-led-subsystem
+++ a/MAINTAINERS
@@ -4075,6 +4075,7 @@ F:	Documentation/scsi/53c700.txt
 F:	drivers/scsi/53c700*
 
 LED SUBSYSTEM
+M:	Bryan Wu <bryan.wu@canonical.com>
 M:	Richard Purdie <rpurdie@rpsys.net>
 S:	Maintained
 F:	drivers/leds/
_
Subject: Subject: MAINTAINERS: add maintainer for LED subsystem

Patches currently in -mm which might be from bryan.wu@canonical.com are

maintainers-add-maintainer-for-led-subsystem.patch

