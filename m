From: akpm@linux-foundation.org
Subject: + maintainers-fix-usb-video-class-mail-list-address.patch added to -mm tree
Date: Fri, 12 Sep 2008 12:47:14 -0700
Message-ID: <200809121947.m8CJlEWa000792@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753529AbYILTrs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Sep 2008 15:47:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tom.leiming@gmail.com, mchehab@infradead.org


The patch titled
     MAINTAINERS: fix USB VIDEO CLASS mail list address
has been added to the -mm tree.  Its filename is
     maintainers-fix-usb-video-class-mail-list-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: fix USB VIDEO CLASS mail list address
From: Ming Lei <tom.leiming@gmail.com>

It should be linux-uvc-devel@lists.berlios.de.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-fix-usb-video-class-mail-list-address MAINTAINERS
--- a/MAINTAINERS~maintainers-fix-usb-video-class-mail-list-address
+++ a/MAINTAINERS
@@ -4398,7 +4398,7 @@ S:	Maintained
 USB VIDEO CLASS
 P:	Laurent Pinchart
 M:	laurent.pinchart@skynet.be
-L:	linx-uvc-devel@berlios.de
+L:	linux-uvc-devel@lists.berlios.de
 L:	video4linux-list@redhat.com
 W:	http://linux-uvc.berlios.de
 S:	Maintained
_

Patches currently in -mm which might be from tom.leiming@gmail.com are

maintainers-fix-usb-video-class-mail-list-address.patch
hci_usb-replace-mb-with-smp_mb.patch

