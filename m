From: akpm@linux-foundation.org
Subject: [merged] aoe-update-copyright-year-in-touched-files.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:21:43 -0700
Message-ID: <20121005202144.0595C5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:52573 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUVq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:21:46 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so139753wey.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:21:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: aoe: update copyright year in touched files
has been removed from the -mm tree.  Its filename was
     aoe-update-copyright-year-in-touched-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: update copyright year in touched files

Signed-off-by: Ed Cashin <ecashin@coraid.com>
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

diff -puN drivers/block/aoe/aoe.h~aoe-update-copyright-year-in-touched-files drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-update-copyright-year-in-touched-files
+++ a/drivers/block/aoe/aoe.h
@@ -1,4 +1,4 @@
-/* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2012 Coraid, Inc.  See COPYING for GPL terms. */
 #define VERSION "49"
 #define AOE_MAJOR 152
 #define DEVICE_NAME "aoe"
diff -puN drivers/block/aoe/aoeblk.c~aoe-update-copyright-year-in-touched-files drivers/block/aoe/aoeblk.c
--- a/drivers/block/aoe/aoeblk.c~aoe-update-copyright-year-in-touched-files
+++ a/drivers/block/aoe/aoeblk.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2012 Coraid, Inc.  See COPYING for GPL terms. */
 /*
  * aoeblk.c
  * block device routines
diff -puN drivers/block/aoe/aoechr.c~aoe-update-copyright-year-in-touched-files drivers/block/aoe/aoechr.c
--- a/drivers/block/aoe/aoechr.c~aoe-update-copyright-year-in-touched-files
+++ a/drivers/block/aoe/aoechr.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2012 Coraid, Inc.  See COPYING for GPL terms. */
 /*
  * aoechr.c
  * AoE character device driver
diff -puN drivers/block/aoe/aoecmd.c~aoe-update-copyright-year-in-touched-files drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-update-copyright-year-in-touched-files
+++ a/drivers/block/aoe/aoecmd.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2012 Coraid, Inc.  See COPYING for GPL terms. */
 /*
  * aoecmd.c
  * Filesystem request handling methods
diff -puN drivers/block/aoe/aoedev.c~aoe-update-copyright-year-in-touched-files drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-update-copyright-year-in-touched-files
+++ a/drivers/block/aoe/aoedev.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2012 Coraid, Inc.  See COPYING for GPL terms. */
 /*
  * aoedev.c
  * AoE device utility functions; maintains device list.
diff -puN drivers/block/aoe/aoemain.c~aoe-update-copyright-year-in-touched-files drivers/block/aoe/aoemain.c
--- a/drivers/block/aoe/aoemain.c~aoe-update-copyright-year-in-touched-files
+++ a/drivers/block/aoe/aoemain.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2012 Coraid, Inc.  See COPYING for GPL terms. */
 /*
  * aoemain.c
  * Module initialization routines, discover timer
diff -puN drivers/block/aoe/aoenet.c~aoe-update-copyright-year-in-touched-files drivers/block/aoe/aoenet.c
--- a/drivers/block/aoe/aoenet.c~aoe-update-copyright-year-in-touched-files
+++ a/drivers/block/aoe/aoenet.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2012 Coraid, Inc.  See COPYING for GPL terms. */
 /*
  * aoenet.c
  * Ethernet portion of AoE driver
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch

