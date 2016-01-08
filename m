From: akpm@linux-foundation.org
Subject: + maintainers-fix-mic-maintainers-entry.patch added to -mm tree
Date: Thu, 07 Jan 2016 17:07:27 -0800
Message-ID: <568f0bcf./cdAnkoC3WhE8A3Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40773 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbcAHBH2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jan 2016 20:07:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, gregkh@linuxfoundation.org, joe@perches.com, sudeep.dutt@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: fix MIC maintainers entry
has been added to the -mm tree.  Its filename is
     maintainers-fix-mic-maintainers-entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-fix-mic-maintainers-entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-fix-mic-maintainers-entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -5749,11 +5749,11 @@ F:	include/linux/mic_bus.h
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

mm-add-tracepoint-for-scanning-pages-fix.patch
c6x-convert-to-dma_map_ops-fix.patch
maintainers-fix-mic-maintainers-entry.patch

