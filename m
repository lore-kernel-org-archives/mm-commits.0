From: akpm@linux-foundation.org
Subject: - aoe-update-copyright-date.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:16:13 -0800
Message-ID: <200802082015.m18KFsvQ010656@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60892 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756260AbYBHUvf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:51:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     aoe: update copyright date
has been removed from the -mm tree.  Its filename was
     aoe-update-copyright-date.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
