From: akpm@linux-foundation.org
Subject: - doc-isicom-remove-reserved-ioctl-number.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:51:56 -0800
Message-ID: <200702112251.l1BMpu2k015972@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60192 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932770AbXBKWv6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:51:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Doc: isicom, remove reserved ioctl-number
has been removed from the -mm tree.  Its filename was
     doc-isicom-remove-reserved-ioctl-number.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Doc: isicom, remove reserved ioctl-number
From: Jiri Slaby <jirislaby@gmail.com>

Isicom driver no longer registers chardev with ioctl function.  It used to
use for firmware loading.  Remove the reserved letter (M) from
ioctl-number, so that the conflict get away.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ioctl-number.txt |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN Documentation/ioctl-number.txt~doc-isicom-remove-reserved-ioctl-number Documentation/ioctl-number.txt
--- a/Documentation/ioctl-number.txt~doc-isicom-remove-reserved-ioctl-number
+++ a/Documentation/ioctl-number.txt
@@ -94,8 +94,7 @@ Code	Seq#	Include File		Comments
 'L'	00-1F	linux/loop.h
 'L'	E0-FF	linux/ppdd.h		encrypted disk device driver
 					<http://linux01.gwdg.de/~alatham/ppdd.html>
-'M'	all	linux/soundcard.h	conflict!
-'M'	00-1F	linux/isicom.h		conflict!
+'M'	all	linux/soundcard.h
 'N'	00-1F	drivers/usb/scanner.h
 'P'	all	linux/soundcard.h
 'Q'	all	linux/soundcard.h
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
char-use-more-pci_device-macro.patch
char-cyclades-use-pci_device_id.patch
maintainers-remove-two-dead-e-mail.patch
char-specialix-isr-have-2-params.patch
char-timers-cleanup.patch
fbdev-driver-for-s3-trio-virge-update-2-fix.patch
video-fb-add-true-ref_count-atomicity.patch
video-fb-kzalloc-changes.patch
shrink_slab-handle-bad-shrinkers.patch
