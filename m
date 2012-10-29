From: akpm@linux-foundation.org
Subject: [merged] maintainers-networking-drivers-matches-too-much.patch removed from -mm tree
Date: Mon, 29 Oct 2012 12:49:14 -0700
Message-ID: <20121029194915.054AE100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:65335 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2J2TtQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 15:49:16 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so680464ggm.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 12:49:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, davem@davemloft.net, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: NETWORKING DRIVERS matches too much
has been removed from the -mm tree.  Its filename was
     maintainers-networking-drivers-matches-too-much.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
drm-i915-optimize-div_round_closest-call.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch

