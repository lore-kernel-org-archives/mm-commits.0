From: akpm@linux-foundation.org
Subject: + maintainers-add-videobuf2-maintainers.patch added to -mm tree
Date: Tue, 07 Jun 2011 14:37:24 -0700
Message-ID: <201106072137.p57LbOJo028408@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754630Ab1FGViG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2011 17:38:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com, mchehab@infradead.org


The patch titled
     MAINTAINERS: add videobuf2 maintainers
has been added to the -mm tree.  Its filename is
     maintainers-add-videobuf2-maintainers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: add videobuf2 maintainers
From: Pawel Osciak <pawel@osciak.com>

Add maintainers for the videobuf2 V4L2 driver framework.

Signed-off-by: Pawel Osciak <pawel@osciak.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN MAINTAINERS~maintainers-add-videobuf2-maintainers MAINTAINERS
--- a/MAINTAINERS~maintainers-add-videobuf2-maintainers
+++ a/MAINTAINERS
@@ -6734,6 +6734,14 @@ S:	Maintained
 F:	Documentation/filesystems/vfat.txt
 F:	fs/fat/
 
+VIDEOBUF2 FRAMEWORK
+M:	Pawel Osciak <pawel@osciak.com>
+M:	Marek Szyprowski <m.szyprowski@samsung.com>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/video/videobuf2-*
+F:	include/media/videobuf2-*
+
 VIRTIO CONSOLE DRIVER
 M:	Amit Shah <amit.shah@redhat.com>
 L:	virtualization@lists.linux-foundation.org
_

Patches currently in -mm which might be from pawel@osciak.com are

maintainers-add-videobuf2-maintainers.patch

