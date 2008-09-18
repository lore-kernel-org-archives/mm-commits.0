From: akpm@linux-foundation.org
Subject: - maintainers-fix-usb-video-class-mail-list-address.patch removed from -mm tree
Date: Thu, 18 Sep 2008 13:56:10 -0700
Message-ID: <200809182056.m8IKuAK3019171@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754715AbYIRU4U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Sep 2008 16:56:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tom.leiming@gmail.com, laurent.pinchart@skynet.be, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: fix USB VIDEO CLASS mail list address
has been removed from the -mm tree.  Its filename was
     maintainers-fix-usb-video-class-mail-list-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -4365,7 +4365,7 @@ S:	Maintained
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

origin.patch
hci_usb-replace-mb-with-smp_mb.patch

