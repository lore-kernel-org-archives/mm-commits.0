From: akpm@linux-foundation.org
Subject: [merged] aoe-update-copyright-date.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:36:58 -0700
Message-ID: <51db14da.SwsEMk/r3s/VnnY6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295Ab3GHTg6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:36:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ecashin@coraid.com

Subject: [merged] aoe-update-copyright-date.patch removed from -mm tree
To: ecashin@coraid.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:36:58 -0700


The patch titled
     Subject: aoe: update copyright date
has been removed from the -mm tree.  Its filename was
     aoe-update-copyright-date.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: aoe: update copyright date

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h    |    2 +-
 drivers/block/aoe/aoecmd.c |    2 +-
 drivers/block/aoe/aoedev.c |    2 +-
 drivers/block/aoe/aoenet.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-update-copyright-date drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-update-copyright-date
+++ a/drivers/block/aoe/aoe.h
@@ -1,4 +1,4 @@
-/* Copyright (c) 2012 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2013 Coraid, Inc.  See COPYING for GPL terms. */
 #define VERSION "81"
 #define AOE_MAJOR 152
 #define DEVICE_NAME "aoe"
diff -puN drivers/block/aoe/aoecmd.c~aoe-update-copyright-date drivers/block/aoe/aoecmd.c
--- a/drivers/block/aoe/aoecmd.c~aoe-update-copyright-date
+++ a/drivers/block/aoe/aoecmd.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2012 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2013 Coraid, Inc.  See COPYING for GPL terms. */
 /*
  * aoecmd.c
  * Filesystem request handling methods
diff -puN drivers/block/aoe/aoedev.c~aoe-update-copyright-date drivers/block/aoe/aoedev.c
--- a/drivers/block/aoe/aoedev.c~aoe-update-copyright-date
+++ a/drivers/block/aoe/aoedev.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2012 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2013 Coraid, Inc.  See COPYING for GPL terms. */
 /*
  * aoedev.c
  * AoE device utility functions; maintains device list.
diff -puN drivers/block/aoe/aoenet.c~aoe-update-copyright-date drivers/block/aoe/aoenet.c
--- a/drivers/block/aoe/aoenet.c~aoe-update-copyright-date
+++ a/drivers/block/aoe/aoenet.c
@@ -1,4 +1,4 @@
-/* Copyright (c) 2012 Coraid, Inc.  See COPYING for GPL terms. */
+/* Copyright (c) 2013 Coraid, Inc.  See COPYING for GPL terms. */
 /*
  * aoenet.c
  * Ethernet portion of AoE driver
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch

