From: akpm@linux-foundation.org
Subject: +
 documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion.patch added to -mm tree
Date: Wed, 29 Jan 2014 12:04:01 -0800
Message-ID: <52e95eb1.gdJTTkeieEwBERhZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaA2UEC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Jan 2014 15:04:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, greg@kroah.com, andrzej.p@samsung.com, ard.biesheuvel@linaro.org

Subject: + documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion.patch added to -mm tree
To: ard.biesheuvel@linaro.org,andrzej.p@samsung.com,greg@kroah.com
From: akpm@linux-foundation.org
Date: Wed, 29 Jan 2014 12:04:01 -0800


The patch titled
     Subject: Documentation: fix multiple typo occurences s/KenelVersion/KernelVersion/
has been added to the -mm tree.  Its filename is
     documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Documentation: fix multiple typo occurences s/KenelVersion/KernelVersion/

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Greg KH <greg@kroah.com>
Acked-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/configfs-usb-gadget              |   12 +++++-----
 Documentation/ABI/testing/configfs-usb-gadget-acm          |    2 -
 Documentation/ABI/testing/configfs-usb-gadget-ecm          |    2 -
 Documentation/ABI/testing/configfs-usb-gadget-eem          |    2 -
 Documentation/ABI/testing/configfs-usb-gadget-ffs          |    2 -
 Documentation/ABI/testing/configfs-usb-gadget-loopback     |    2 -
 Documentation/ABI/testing/configfs-usb-gadget-mass-storage |    4 +--
 Documentation/ABI/testing/configfs-usb-gadget-ncm          |    2 -
 Documentation/ABI/testing/configfs-usb-gadget-obex         |    2 -
 Documentation/ABI/testing/configfs-usb-gadget-phonet       |    2 -
 Documentation/ABI/testing/configfs-usb-gadget-rndis        |    2 -
 Documentation/ABI/testing/configfs-usb-gadget-serial       |    2 -
 Documentation/ABI/testing/configfs-usb-gadget-sourcesink   |    2 -
 Documentation/ABI/testing/configfs-usb-gadget-subset       |    2 -
 14 files changed, 20 insertions(+), 20 deletions(-)

diff -puN Documentation/ABI/testing/configfs-usb-gadget~documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion Documentation/ABI/testing/configfs-usb-gadget
--- a/Documentation/ABI/testing/configfs-usb-gadget~documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion
+++ a/Documentation/ABI/testing/configfs-usb-gadget
@@ -1,13 +1,13 @@
 What:		/config/usb-gadget
 Date:		Jun 2013
-KenelVersion:	3.11
+KernelVersion:	3.11
 Description:
 		This group contains sub-groups corresponding to created
 		USB gadgets.
 
 What:		/config/usb-gadget/gadget
 Date:		Jun 2013
-KenelVersion:	3.11
+KernelVersion:	3.11
 Description:
 
 		The attributes of a gadget:
@@ -27,7 +27,7 @@ Description:
 
 What:		/config/usb-gadget/gadget/configs
 Date:		Jun 2013
-KenelVersion:	3.11
+KernelVersion:	3.11
 Description:
 		This group contains a USB gadget's configurations
 
@@ -58,20 +58,20 @@ Description:
 
 What:		/config/usb-gadget/gadget/functions
 Date:		Jun 2013
-KenelVersion:	3.11
+KernelVersion:	3.11
 Description:
 		This group contains functions available to this USB gadget.
 
 What:		/config/usb-gadget/gadget/strings
 Date:		Jun 2013
-KenelVersion:	3.11
+KernelVersion:	3.11
 Description:
 		This group contains subdirectories for language-specific
 		strings for this gadget.
 
 What:		/config/usb-gadget/gadget/strings/language
 Date:		Jun 2013
-KenelVersion:	3.11
+KernelVersion:	3.11
 Description:
 		The attributes:
 
diff -puN Documentation/ABI/testing/configfs-usb-gadget-acm~documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion Documentation/ABI/testing/configfs-usb-gadget-acm
--- a/Documentation/ABI/testing/configfs-usb-gadget-acm~documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion
+++ a/Documentation/ABI/testing/configfs-usb-gadget-acm
@@ -1,6 +1,6 @@
 What:		/config/usb-gadget/gadget/functions/acm.name
 Date:		Jun 2013
-KenelVersion:	3.11
+KernelVersion:	3.11
 Description:
 
 		This item contains just one readonly attribute: port_num.
diff -puN Documentation/ABI/testing/configfs-usb-gadget-ecm~documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion Documentation/ABI/testing/configfs-usb-gadget-ecm
--- a/Documentation/ABI/testing/configfs-usb-gadget-ecm~documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion
+++ a/Documentation/ABI/testing/configfs-usb-gadget-ecm
@@ -1,6 +1,6 @@
 What:		/config/usb-gadget/gadget/functions/ecm.name
 Date:		Jun 2013
-KenelVersion:	3.11
+KernelVersion:	3.11
 Description:
 		The attributes:
 
diff -puN Documentation/ABI/testing/configfs-usb-gadget-eem~documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion Documentation/ABI/testing/configfs-usb-gadget-eem
--- a/Documentation/ABI/testing/configfs-usb-gadget-eem~documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion
+++ a/Documentation/ABI/testing/configfs-usb-gadget-eem
@@ -1,6 +1,6 @@
 What:		/config/usb-gadget/gadget/functions/eem.name
 Date:		Jun 2013
-KenelVersion:	3.11
+KernelVersion:	3.11
 Description:
 		The attributes:
 
diff -puN Documentation/ABI/testing/configfs-usb-gadget-ffs~documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion Documentation/ABI/testing/configfs-usb-gadget-ffs
--- a/Documentation/ABI/testing/configfs-usb-gadget-ffs~documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion
+++ a/Documentation/ABI/testing/configfs-usb-gadget-ffs
@@ -1,6 +1,6 @@
 What:		/config/usb-gadget/gadget/functions/ffs.name
 Date:		Nov 2013
-KenelVersion:	3.13
+KernelVersion:	3.13
 Description:	The purpose of this directory is to create and remove it.
 
 		A corresponding USB function instance is created/removed.
diff -puN Documentation/ABI/testing/configfs-usb-gadget-loopback~documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion Documentation/ABI/testing/configfs-usb-gadget-loopback
--- a/Documentation/ABI/testing/configfs-usb-gadget-loopback~documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion
+++ a/Documentation/ABI/testing/configfs-usb-gadget-loopback
@@ -1,6 +1,6 @@
 What:		/config/usb-gadget/gadget/functions/Loopback.name
 Date:		Nov 2013
-KenelVersion:	3.13
+KernelVersion:	3.13
 Description:
 		The attributes:
 
diff -puN Documentation/ABI/testing/configfs-usb-gadget-mass-storage~documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion Documentation/ABI/testing/configfs-usb-gadget-mass-storage
--- a/Documentation/ABI/testing/configfs-usb-gadget-mass-storage~documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion
+++ a/Documentation/ABI/testing/configfs-usb-gadget-mass-storage
@@ -1,6 +1,6 @@
 What:		/config/usb-gadget/gadget/functions/mass_storage.name
 Date:		Oct 2013
-KenelVersion:	3.13
+KernelVersion:	3.13
 Description:
 		The attributes:
 
@@ -13,7 +13,7 @@ Description:
 
 What:		/config/usb-gadget/gadget/functions/mass_storage.name/lun.name
 Date:		Oct 2013
-KenelVersion:	3.13
+KernelVersion:	3.13
 Description:
 		The attributes:
 
diff -puN Documentation/ABI/testing/configfs-usb-gadget-ncm~documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion Documentation/ABI/testing/configfs-usb-gadget-ncm
--- a/Documentation/ABI/testing/configfs-usb-gadget-ncm~documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion
+++ a/Documentation/ABI/testing/configfs-usb-gadget-ncm
@@ -1,6 +1,6 @@
 What:		/config/usb-gadget/gadget/functions/ncm.name
 Date:		Jun 2013
-KenelVersion:	3.11
+KernelVersion:	3.11
 Description:
 		The attributes:
 
diff -puN Documentation/ABI/testing/configfs-usb-gadget-obex~documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion Documentation/ABI/testing/configfs-usb-gadget-obex
--- a/Documentation/ABI/testing/configfs-usb-gadget-obex~documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion
+++ a/Documentation/ABI/testing/configfs-usb-gadget-obex
@@ -1,6 +1,6 @@
 What:		/config/usb-gadget/gadget/functions/obex.name
 Date:		Jun 2013
-KenelVersion:	3.11
+KernelVersion:	3.11
 Description:
 
 		This item contains just one readonly attribute: port_num.
diff -puN Documentation/ABI/testing/configfs-usb-gadget-phonet~documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion Documentation/ABI/testing/configfs-usb-gadget-phonet
--- a/Documentation/ABI/testing/configfs-usb-gadget-phonet~documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion
+++ a/Documentation/ABI/testing/configfs-usb-gadget-phonet
@@ -1,6 +1,6 @@
 What:		/config/usb-gadget/gadget/functions/phonet.name
 Date:		Jun 2013
-KenelVersion:	3.11
+KernelVersion:	3.11
 Description:
 
 		This item contains just one readonly attribute: ifname.
diff -puN Documentation/ABI/testing/configfs-usb-gadget-rndis~documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion Documentation/ABI/testing/configfs-usb-gadget-rndis
--- a/Documentation/ABI/testing/configfs-usb-gadget-rndis~documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion
+++ a/Documentation/ABI/testing/configfs-usb-gadget-rndis
@@ -1,6 +1,6 @@
 What:		/config/usb-gadget/gadget/functions/rndis.name
 Date:		Jun 2013
-KenelVersion:	3.11
+KernelVersion:	3.11
 Description:
 		The attributes:
 
diff -puN Documentation/ABI/testing/configfs-usb-gadget-serial~documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion Documentation/ABI/testing/configfs-usb-gadget-serial
--- a/Documentation/ABI/testing/configfs-usb-gadget-serial~documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion
+++ a/Documentation/ABI/testing/configfs-usb-gadget-serial
@@ -1,6 +1,6 @@
 What:		/config/usb-gadget/gadget/functions/gser.name
 Date:		Jun 2013
-KenelVersion:	3.11
+KernelVersion:	3.11
 Description:
 
 		This item contains just one readonly attribute: port_num.
diff -puN Documentation/ABI/testing/configfs-usb-gadget-sourcesink~documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion Documentation/ABI/testing/configfs-usb-gadget-sourcesink
--- a/Documentation/ABI/testing/configfs-usb-gadget-sourcesink~documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion
+++ a/Documentation/ABI/testing/configfs-usb-gadget-sourcesink
@@ -1,6 +1,6 @@
 What:		/config/usb-gadget/gadget/functions/SourceSink.name
 Date:		Nov 2013
-KenelVersion:	3.13
+KernelVersion:	3.13
 Description:
 		The attributes:
 
diff -puN Documentation/ABI/testing/configfs-usb-gadget-subset~documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion Documentation/ABI/testing/configfs-usb-gadget-subset
--- a/Documentation/ABI/testing/configfs-usb-gadget-subset~documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion
+++ a/Documentation/ABI/testing/configfs-usb-gadget-subset
@@ -1,6 +1,6 @@
 What:		/config/usb-gadget/gadget/functions/geth.name
 Date:		Jun 2013
-KenelVersion:	3.11
+KernelVersion:	3.11
 Description:
 		The attributes:
 
_

Patches currently in -mm which might be from ard.biesheuvel@linaro.org are

origin.patch
documentation-fix-multiple-typo-occurences-s-kenelversion-kernelversion.patch

