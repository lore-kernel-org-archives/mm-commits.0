From: akpm@linux-foundation.org
Subject: + aoe-update-copyright-year-in-touched-files.patch added to -mm tree
Date: Fri, 31 Aug 2012 13:12:13 -0700
Message-ID: <20120831201214.3A8191E004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:35690 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916Ab2HaUMO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Aug 2012 16:12:14 -0400
Received: by mail-yx0-f202.google.com with SMTP id q6so383761yen.1
        for <mm-commits@vger.kernel.org>; Fri, 31 Aug 2012 13:12:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com


The patch titled
     Subject: aoe: update copyright year in touched files
has been added to the -mm tree.  Its filename is
     aoe-update-copyright-year-in-touched-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

aoe-for-performance-support-larger-packet-payloads.patch
aoe-kernel-thread-handles-i-o-completions-for-simple-locking.patch
aoe-become-i-o-request-queue-handler-for-increased-user-control.patch
aoe-use-a-kernel-thread-for-transmissions.patch
aoe-use-packets-that-work-with-the-smallest-mtu-local-interface.patch
aoe-failover-remote-interface-based-on-aoe_deadsecs-parameter.patch
aoe-do-revalidation-steps-in-order.patch
aoe-disallow-unsupported-aoe-minor-addresses.patch
aoe-associate-frames-with-the-aoe-storage-target.patch
aoe-increase-net_device-reference-count-while-using-it.patch
aoe-remove-unused-code-and-add-cosmetic-improvements.patch
aoe-update-internal-version-number-to-49.patch
aoe-update-copyright-year-in-touched-files.patch
aoe-update-documentation-with-new-url-and-vm-settings-reference.patch

