From: akpm@linux-foundation.org
Subject: + aoe-update-copyright-date.patch added to -mm tree
Date: Tue, 02 Jul 2013 14:43:42 -0700
Message-ID: <51d3498e.1MDcL2Wq7Yh1jJ1A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59384 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071Ab3GBVnn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jul 2013 17:43:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ecashin@coraid.com

Subject: + aoe-update-copyright-date.patch added to -mm tree
To: ecashin@coraid.com
From: akpm@linux-foundation.org
Date: Tue, 02 Jul 2013 14:43:42 -0700


The patch titled
     Subject: aoe: update copyright date
has been added to the -mm tree.  Its filename is
     aoe-update-copyright-date.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/aoe-update-copyright-date.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/aoe-update-copyright-date.patch

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

aoe-perform-i-o-completions-in-parallel.patch
aoe-update-copyright-date.patch
aoe-update-internal-version-number-to-v83.patch

