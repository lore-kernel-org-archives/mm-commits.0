From: akpm@linux-foundation.org
Subject: + usbdevfs_urb-__user-annotation.patch added to -mm tree
Date: Tue, 18 Dec 2007 15:37:25 -0800
Message-ID: <200712182337.lBINbP0k027712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40950 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753566AbXLRXh1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 18:37:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, greg@kroah.com


The patch titled
     usbdevfs_urb: __user annotation
has been added to the -mm tree.  Its filename is
     usbdevfs_urb-__user-annotation.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

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
usb-storage-initializersc-fix-signedness-difference.patch
usbdevfs_urb-__user-annotation.patch
vgacon-fix-sparse-warning-about-shadowing-i-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-p-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-rotate-symbol.patch
logo-move-declarations-of-logos-to-linux_logoh.patch
logo-move-declarations-of-logos-to-linux_logoh-fix.patch
