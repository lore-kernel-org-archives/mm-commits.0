From: akpm@linux-foundation.org
Subject: + maintainers-update-a-file-name-in-drivers-acpi.patch added to
 -mm tree
Date: Tue, 01 Dec 2015 16:40:59 -0800
Message-ID: <565e3e1b.B1GiCrZUdjSUnT2X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60759 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196AbbLBAk7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2015 19:40:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update a file name in drivers/acpi/
has been added to the -mm tree.  Its filename is
     maintainers-update-a-file-name-in-drivers-acpi.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-a-file-name-in-drivers-acpi.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-a-file-name-in-drivers-acpi.patch

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
Subject: MAINTAINERS: update a file name in drivers/acpi/

We renamed drivers/acpi/video.c to drivers/acpi/acpi_video.c in commit
14ca7a47d0ab ('acpi-video-detect: video: Make video_detect code part of
the video module').

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-a-file-name-in-drivers-acpi MAINTAINERS
--- a/MAINTAINERS~maintainers-update-a-file-name-in-drivers-acpi
+++ a/MAINTAINERS
@@ -318,7 +318,7 @@ M:	Zhang Rui <rui.zhang@intel.com>
 L:	linux-acpi@vger.kernel.org
 W:	https://01.org/linux-acpi
 S:	Supported
-F:	drivers/acpi/video.c
+F:	drivers/acpi/acpi_video.c
 
 ACPI WMI DRIVER
 L:	platform-driver-x86@vger.kernel.org
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

mm-add-tracepoint-for-scanning-pages-fix.patch
maintainers-update-a-file-name-in-drivers-acpi.patch
c6x-convert-to-dma_map_ops-fix.patch

