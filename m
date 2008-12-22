From: akpm@linux-foundation.org
Subject: + maintainers-mark-linux-uvc-devel-as-subscribers-only.patch added to -mm tree
Date: Mon, 22 Dec 2008 14:38:25 -0800
Message-ID: <200812222238.mBMMcPks024702@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753554AbYLVWid (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Dec 2008 17:38:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, laurent.pinchart@skynet.be, mchehab@infradead.org


The patch titled
     MAINTAINERS: mark linux-uvc-devel as subscribers only
has been added to the -mm tree.  Its filename is
     maintainers-mark-linux-uvc-devel-as-subscribers-only.patch

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
Subject: MAINTAINERS: mark linux-uvc-devel as subscribers only
From: Jiri Slaby <jirislaby@gmail.com>

Posting to linux-uvc-devel is restricted to members.  You can subscribe to
the list at ...

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-mark-linux-uvc-devel-as-subscribers-only MAINTAINERS
--- a/MAINTAINERS~maintainers-mark-linux-uvc-devel-as-subscribers-only
+++ a/MAINTAINERS
@@ -4580,7 +4580,7 @@ S:	Maintained
 USB VIDEO CLASS
 P:	Laurent Pinchart
 M:	laurent.pinchart@skynet.be
-L:	linux-uvc-devel@lists.berlios.de
+L:	linux-uvc-devel@lists.berlios.de (subscribers-only)
 L:	video4linux-list@redhat.com
 W:	http://linux-uvc.berlios.de
 S:	Maintained
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
v4l-usbvideo-fix-module-ref-count-check.patch
maintainers-mark-linux-uvc-devel-as-subscribers-only.patch
8250_pci-add-support-for-netmos-9835.patch
dmi-add-dmi_match.patch
ata-piix-cleanup-dmi-strings-checking.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

