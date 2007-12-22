From: akpm@linux-foundation.org
Subject: + aoe-update-copyright-date.patch added to -mm tree
Date: Fri, 21 Dec 2007 22:04:02 -0800
Message-ID: <200712220604.lBM642uk020146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39709 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751358AbXLVGEG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Dec 2007 01:04:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com, greg@kroah.com


The patch titled
     aoe: update copyright date
has been added to the -mm tree.  Its filename is
     aoe-update-copyright-date.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aoe: update copyright date
From: "Ed L. Cashin" <ecashin@coraid.com>

Update the year in the copyright notices.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h     |    2 +-
 drivers/block/aoe/aoeblk.c  |    2 +-
 drivers/block/aoe/aoechr.c  |    2 +-
 drivers/block/aoe/aoecmd.c  |    2 +-
 drivers/block/aoe/aoedev.c  |    2 +-
 drivers/block/aoe/aoemain.c |    2 +-
 drivers/block/aoe/aoenet.c  |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-update-copyright-date drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-update-copyright-date
+++ a/drivers/block/aoe/aoe.h
@@ -1,4 +1,4 @@
-/* Copyright (c) 2006 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
 #define VERSION "47"
 #define AOE_MAJOR 152
 #define DEVICE_NAME "aoe"
diff -puN drivers/block/aoe/aoeblk.c~aoe-update-copyright-date drivers/block/aoe/aoeblk.c
--- a/drivers/block/aoe/aoeblk.c~aoe-update-copyright-date
+++ a/drivers/block/aoe/aoeblk.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2006 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
 /*
  * aoeblk.c
  * block device routines
diff -puN drivers/block/aoe/aoechr.c~aoe-update-copyright-date drivers/block/aoe/aoechr.c
--- a/drivers/block/aoe/aoechr.c~aoe-update-copyright-date
+++ a/drivers/block/aoe/aoechr.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2006 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
 /*
  * aoechr.c
  * AoE character device driver
diff -puN drivers/block/aoe/aoecmd.c~aoe-update-copyright-date drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-update-copyright-date
+++ a/drivers/block/aoe/aoecmd.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2006 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
 /*
  * aoecmd.c
  * Filesystem request handling methods
diff -puN drivers/block/aoe/aoedev.c~aoe-update-copyright-date drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-update-copyright-date
+++ a/drivers/block/aoe/aoedev.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2006 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
 /*
  * aoedev.c
  * AoE device utility functions; maintains device list.
diff -puN drivers/block/aoe/aoemain.c~aoe-update-copyright-date drivers/block/aoe/aoemain.c
--- a/drivers/block/aoe/aoemain.c~aoe-update-copyright-date
+++ a/drivers/block/aoe/aoemain.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2006 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
 /*
  * aoemain.c
  * Module initialization routines, discover timer
diff -puN drivers/block/aoe/aoenet.c~aoe-update-copyright-date drivers/block/aoe/aoenet.c
--- a/drivers/block/aoe/aoenet.c~aoe-update-copyright-date
+++ a/drivers/block/aoe/aoenet.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2006 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
 /*
  * aoenet.c
  * Ethernet portion of AoE driver
_

Patches currently in -mm which might be from ecashin@coraid.com are

aoe-bring-driver-version-number-to-47.patch
aoe-handle-multiple-network-paths-to-aoe-device.patch
aoe-mac_addr-avoid-64-bit-arch-compiler-warnings.patch
aoe-clean-up-udev-configuration-example.patch
aoe-eliminate-goto-and-improve-readability.patch
aoe-user-can-ask-driver-to-forget-previously-detected-devices.patch
aoe-dynamically-allocate-a-capped-number-of-skbs-when-necessary.patch
aoe-only-install-new-aoe-device-once.patch
aoe-add-module-parameter-for-users-who-need-more-outstanding-i-o.patch
aoe-the-aoeminor-doesnt-need-a-long-format.patch
aoe-make-error-messages-more-specific.patch
aoe-update-copyright-date.patch
aoe-statically-initialise-devlist_lock.patch
