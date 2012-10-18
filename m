From: akpm@linux-foundation.org
Subject: + maintainers-networking-drivers-matches-too-much.patch added to -mm tree
Date: Thu, 18 Oct 2012 15:15:55 -0700
Message-ID: <20121018221555.95D0E1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:50909 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab2JRWP4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Oct 2012 18:15:56 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so1144407ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 18 Oct 2012 15:15:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, davem@davemloft.net, joe@perches.com


The patch titled
     Subject: MAINTAINERS: NETWORKING DRIVERS matches too much
has been added to the -mm tree.  Its filename is
     maintainers-networking-drivers-matches-too-much.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jean Delvare <khali@linux-fr.org>
Subject: MAINTAINERS: NETWORKING DRIVERS matches too much

File pattern include/linux/*device.h matches too much, including
completely unrelated files.  Replace it with an explicit list of network
device-related header files.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Joe Perches <joe@perches.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-networking-drivers-matches-too-much MAINTAINERS
--- a/MAINTAINERS~maintainers-networking-drivers-matches-too-much
+++ a/MAINTAINERS
@@ -5067,7 +5067,13 @@ T:	git git://git.kernel.org/pub/scm/linu
 S:	Odd Fixes
 F:	drivers/net/
 F:	include/linux/if_*
-F:	include/linux/*device.h
+F:	include/linux/netdevice.h
+F:	include/linux/arcdevice.h
+F:	include/linux/etherdevice.h
+F:	include/linux/fcdevice.h
+F:	include/linux/fddidevice.h
+F:	include/linux/hippidevice.h
+F:	include/linux/inetdevice.h
 
 NETXEN (1/10) GbE SUPPORT
 M:	Sony Chacko <sony.chacko@qlogic.com>
_

Patches currently in -mm which might be from khali@linux-fr.org are

linux-next.patch
drm-i915-optimize-div_round_closest-call.patch
maintainers-networking-drivers-matches-too-much.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch

