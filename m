From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-gianfar_ptp-after-renaming.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:14:32 -0700
Message-ID: <20121005201433.1D25020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:54984 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab2JEUOe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:14:34 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so57836wib.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:14:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, jeffrey.t.kirsher@intel.com, richardcochran@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: Update gianfar_ptp after renaming
has been removed from the -mm tree.  Its filename was
     maintainers-update-gianfar_ptp-after-renaming.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -5556,7 +5556,7 @@ S:	Maintained
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

origin.patch
linux-next.patch
kstrto-add-documentation.patch
simple_strto-annotate-function-as-obsolete.patch

