From: akpm@linux-foundation.org
Subject: + maintainers-update-gianfar_ptp-after-renaming.patch added to -mm tree
Date: Fri, 31 Aug 2012 15:45:31 -0700
Message-ID: <20120831224532.0E2C65C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:42323 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140Ab2HaWpf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Aug 2012 18:45:35 -0400
Received: by lbbge1 with SMTP id ge1so117759lbb.1
        for <mm-commits@vger.kernel.org>; Fri, 31 Aug 2012 15:45:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, jeffrey.t.kirsher@intel.com, richardcochran@gmail.com


The patch titled
     From: Joe Perches <joe@perches.com>
has been added to the -mm tree.  Its filename is
     maintainers-update-gianfar_ptp-after-renaming.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: Update gianfar_ptp after renaming

commit ec21e2ec36769 ("freescale: Move the Freescale drivers")
moved the files, update the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-gianfar_ptp-after-renaming MAINTAINERS
--- a/MAINTAINERS~maintainers-update-gianfar_ptp-after-renaming
+++ a/MAINTAINERS
@@ -5508,7 +5508,7 @@ S:	Maintained
 W:	http://linuxptp.sourceforge.net/
 F:	Documentation/ABI/testing/sysfs-ptp
 F:	Documentation/ptp/*
-F:	drivers/net/gianfar_ptp.c
+F:	drivers/net/ethernet/freescale/gianfar_ptp.c
 F:	drivers/net/phy/dp83640*
 F:	drivers/ptp/*
 F:	include/linux/ptp_cl*
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
maintainers-update-gianfar_ptp-after-renaming.patch

