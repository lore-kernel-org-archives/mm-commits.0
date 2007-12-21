From: akpm@linux-foundation.org
Subject: - usbdevfs_urb-__user-annotation.patch removed from -mm tree
Date: Fri, 21 Dec 2007 14:08:56 -0800
Message-ID: <200712212208.lBLM8utp001742@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39920 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756312AbXLUWJd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 17:09:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usbdevfs_urb: __user annotation
has been removed from the -mm tree.  Its filename was
     usbdevfs_urb-__user-annotation.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: usbdevfs_urb: __user annotation
=46rom: Marcin =C5=9Alusarz <marcin.slusarz@gmail.com>

Signed-off-by: Marcin =C5=9Alusarz <marcin.slusarz@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/usbdevice_fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/usbdevice_fs.h~usbdevfs_urb-__user-annotation i=
nclude/linux/usbdevice_fs.h
--- a/include/linux/usbdevice_fs.h~usbdevfs_urb-__user-annotation
+++ a/include/linux/usbdevice_fs.h
@@ -104,7 +104,7 @@ struct usbdevfs_urb {
 	int error_count;
 	unsigned int signr;	/* signal to be sent on completion,
 				  or 0 if none should be sent. */
-	void *usercontext;
+	void __user *usercontext;
 	struct usbdevfs_iso_packet_desc iso_frame_desc[0];
 };
=20
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com a=
re

git-alsa.patch
ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol-checkpatch-fi=
xes.patch
vgacon-fix-sparse-warning-about-shadowing-i-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-p-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-rotate-symbol.patch
logo-move-declarations-of-logos-to-linux_logoh.patch
logo-move-declarations-of-logos-to-linux_logoh-fix.patch
