From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-firmware-isci.patch removed from -mm tree
Date: Mon, 07 Jan 2013 11:26:29 -0800
Message-ID: <20130107192629.C58C3820059@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:39705 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375Ab3AGT0b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:26:31 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so2113990ggn.5
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:26:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cesarb@cesarb.net, JBottomley@Parallels.com, ben@decadent.org.uk, dan.j.williams@intel.com, dave.jiang@intel.com, intel-linux-scu@intel.com, lukasz.dorau@intel.com, maciej.patelczyk@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove firmware/isci/
has been removed from the -mm tree.  Its filename was
     maintainers-remove-firmware-isci.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: MAINTAINERS: remove firmware/isci/

This directory was removed by commit 7d99b3a ("isci, firmware: Remove isci
fallback parameter blob and generator").

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Intel SCU Linux support <intel-linux-scu@intel.com>
Cc: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: Maciej Patelczyk <maciej.patelczyk@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-firmware-isci MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-firmware-isci
+++ a/MAINTAINERS
@@ -3971,7 +3971,6 @@ L:	linux-scsi@vger.kernel.org
 T:	git git://git.code.sf.net/p/intel-sas/isci
 S:	Supported
 F:	drivers/scsi/isci/
-F:	firmware/isci/
 
 INTEL IDLE DRIVER
 M:	Len Brown <lenb@kernel.org>
_

Patches currently in -mm which might be from cesarb@cesarb.net are

origin.patch
linux-next.patch

