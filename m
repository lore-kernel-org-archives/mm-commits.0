From: akpm@linux-foundation.org
Subject: + usbh-kernel-doc-additions.patch added to -mm tree
Date: Thu, 19 Jul 2007 14:42:50 -0700
Message-ID: <200707192142.l6JLgoDi024521@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39948 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752417AbXGSVnc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 17:43:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, greg@kroah.com


The patch titled
     usb.h kernel-doc additions
has been added to the -mm tree.  Its filename is
     usbh-kernel-doc-additions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usb.h kernel-doc additions
From: Randy Dunlap <randy.dunlap@oracle.com>

Add kernel-doc entries in <linux/usb.h> for:

Warning(linux-2.6.22-git12//include/linux/usb.h:162): No description found for parameter 'intf_assoc'
Warning(linux-2.6.22-git12//include/linux/usb.h:268): No description found for parameter 'intf_assoc[USB_MAXIADS]'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/usb.h |    2 ++
 1 files changed, 2 insertions(+)

diff -puN include/linux/usb.h~usbh-kernel-doc-additions include/linux/usb.h
--- a/include/linux/usb.h~usbh-kernel-doc-additions
+++ a/include/linux/usb.h
@@ -94,6 +94,7 @@ enum usb_interface_condition {
  * 	endpoint configurations.  They will be in no particular order.
  * @num_altsetting: number of altsettings defined.
  * @cur_altsetting: the current altsetting.
+ * @intf_assoc: interface association descriptor
  * @driver: the USB driver that is bound to this interface.
  * @minor: the minor number assigned to this interface, if this
  *	interface is bound to a driver that uses the USB major number.
@@ -213,6 +214,7 @@ struct usb_interface_cache {
  * @desc: the device's configuration descriptor.
  * @string: pointer to the cached version of the iConfiguration string, if
  *	present for this configuration.
+ * @intf_assoc: list of any interface association descriptors in this config
  * @interface: array of pointers to usb_interface structures, one for each
  *	interface in the configuration.  The number of interfaces is stored
  *	in desc.bNumInterfaces.  These pointers are valid only while the
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
git-alsa.patch
git-mtd.patch
aha152x-in-debug-mode.patch
git-unionfs.patch
git-ipwireless_cs.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
i2ch-kernel-doc-additions.patch
irqh-fix-kernel-doc.patch
usbh-kernel-doc-additions.patch
docbook-bad-file-references.patch
profile-likely-unlikely-macros.patch
