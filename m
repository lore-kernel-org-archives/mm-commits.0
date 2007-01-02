From: akpm@osdl.org
Subject: + doc-isicom-remove-reserved-ioctl-number.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:09:57 -0800
Message-ID: <200701022109.l02L9vEW029736@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60701 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964976AbXABVKK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:10:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com


The patch titled
     Doc: isicom, remove reserved ioctl-number
has been added to the -mm tree.  Its filename is
     doc-isicom-remove-reserved-ioctl-number.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Doc: isicom, remove reserved ioctl-number
From: Jiri Slaby <jirislaby@gmail.com>

Isicom driver no longer registers chardev with ioctl function.  It used to
use for firmware loading.  Remove the reserved letter (M) from
ioctl-number, so that the conflict get away.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/ioctl-number.txt |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

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

git-input.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-isicom-remove-tty_hangwakeup-bottomhalves.patch
mxser-remove-ambiguous-redefinition-of-init_work.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
char-isicom-fix-locking-in-isr.patch
char-isicom-augment-card_reset.patch
char-isicom-check-card-state-in-isr.patch
char-isicom-support-higher-rates.patch
char-isicom-correct-probing-removing.patch
char-tty_wakeup-cleanup.patch
char-mxser_new-mark-init-functions.patch
char-mxser_new-remove-useless-spinlock.patch
char-serial167-cleanup.patch
char-n_r3964-cleanup.patch
char-mxser_new-remove-unused-stuff.patch
char-mxser-obsolete-old-nonexperimental-new.patch
char-mxser_new-remove-tty_wakeup-bottomhalf.patch
char-mxser_new-clean-request_irq-call.patch
doc-isicom-remove-reserved-ioctl-number.patch
shrink_slab-handle-bad-shrinkers.patch
