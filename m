From: akpm@linux-foundation.org
Subject: + usb-serial-cp2101-add-enfora-gsm2228.patch added to -mm tree
Date: Thu, 30 Oct 2008 13:52:38 -0700
Message-ID: <200810302052.m9UKqcAb002790@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753771AbYJ3UxN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 16:53:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: damir@mimas.ru, greg@kroah.com


The patch titled
     usb-serial: cp2101: add Enfora GSM2228
has been added to the -mm tree.  Its filename is
     usb-serial-cp2101-add-enfora-gsm2228.patch

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
Subject: usb-serial: cp2101: add Enfora GSM2228
From: Damir N Abdullin <damir@mimas.ru <mailto:damir@mimas.ru>>

Enfora GSM2228 based on Cygnal Integrated Products chip uses the same
cp2101 driver.

Signed-off-by: Damir N Abdullin <damir@mimas.ru <mailto:damir@mimas.ru>>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/cp2101.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/usb/serial/cp2101.c~usb-serial-cp2101-add-enfora-gsm2228 drivers/usb/serial/cp2101.c
--- a/drivers/usb/serial/cp2101.c~usb-serial-cp2101-add-enfora-gsm2228
+++ a/drivers/usb/serial/cp2101.c
@@ -67,6 +67,7 @@ static struct usb_device_id id_table [] 
 	{ USB_DEVICE(0x10C4, 0x800A) }, /* SPORTident BSM7-D-USB main station */
 	{ USB_DEVICE(0x10C4, 0x803B) }, /* Pololu USB-serial converter */
 	{ USB_DEVICE(0x10C4, 0x8053) }, /* Enfora EDG1228 */
+	{ USB_DEVICE(0x10C4, 0x8054) }, /* Enfora GSM2228 */
 	{ USB_DEVICE(0x10C4, 0x8066) }, /* Argussoft In-System Programmer */
 	{ USB_DEVICE(0x10C4, 0x807A) }, /* Crumb128 board */
 	{ USB_DEVICE(0x10C4, 0x80CA) }, /* Degree Controls Inc */
_

Patches currently in -mm which might be from damir@mimas.ru are

usb-serial-cp2101-add-enfora-gsm2228.patch

