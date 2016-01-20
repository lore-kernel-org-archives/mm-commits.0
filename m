From: akpm@linux-foundation.org
Subject: [folded-merged] maintainers-fix-mic-maintainers-entry.patch
 removed from -mm tree
Date: Wed, 20 Jan 2016 14:47:12 -0800
Message-ID: <56a00e70.pX69XgwyHN0UaqXJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43232 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbcATWrN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 17:47:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, gregkh@linuxfoundation.org, joe@perches.com, sudeep.dutt@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: fix MIC maintainers entry
has been removed from the -mm tree.  Its filename was
     maintainers-fix-mic-maintainers-entry.patch

This patch was dropped because it was folded into maintainers-add-git-url-for-apm-driver.patch

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: MAINTAINERS: fix MIC maintainers entry

There were some missing colons so we stop parsing the MIC maintainers
entry early.  It means that:

    ./scripts/get_maintainer.pl -f drivers/misc/mic/card/mic_virtio.c

doesn't work.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-fix-mic-maintainers-entry MAINTAINERS
--- a/MAINTAINERS~maintainers-fix-mic-maintainers-entry
+++ a/MAINTAINERS
@@ -5755,11 +5755,11 @@ F:	include/linux/mic_bus.h
 F:	include/linux/scif.h
 F:	include/uapi/linux/mic_common.h
 F: 	include/uapi/linux/mic_ioctl.h
-F	include/uapi/linux/scif_ioctl.h
+F:	include/uapi/linux/scif_ioctl.h
 F:	drivers/misc/mic/
 F:	drivers/dma/mic_x100_dma.c
 F:	drivers/dma/mic_x100_dma.h
-F	Documentation/mic/
+F:	Documentation/mic/
 
 INTEL PMC/P-Unit IPC DRIVER
 M:	Zha Qipeng<qipeng.zha@intel.com>
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

maintainers-add-git-url-for-apm-driver.patch

