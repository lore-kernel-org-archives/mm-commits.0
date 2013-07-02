From: akpm@linux-foundation.org
Subject: + aoe-update-internal-version-number-to-v83.patch added to -mm
 tree
Date: Tue, 02 Jul 2013 14:43:43 -0700
Message-ID: <51d3498f.RryRa+q3+4poixsL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59386 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202Ab3GBVno (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jul 2013 17:43:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ecashin@coraid.com

Subject: + aoe-update-internal-version-number-to-v83.patch added to -mm tree
To: ecashin@coraid.com
From: akpm@linux-foundation.org
Date: Tue, 02 Jul 2013 14:43:43 -0700


The patch titled
     Subject: aoe: update internal version number to v83
has been added to the -mm tree.  Its filename is
     aoe-update-internal-version-number-to-v83.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/aoe-update-internal-version-number-to-v83.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/aoe-update-internal-version-number-to-v83.patch

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
Subject: aoe: update internal version number to v83

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/aoe/aoe.h~aoe-update-internal-version-number-to-v83 drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-update-internal-version-number-to-v83
+++ a/drivers/block/aoe/aoe.h
@@ -1,5 +1,5 @@
 /* Copyright (c) 2013 Coraid, Inc.  See COPYING for GPL terms. */
-#define VERSION "81"
+#define VERSION "83"
 #define AOE_MAJOR 152
 #define DEVICE_NAME "aoe"
 
_

Patches currently in -mm which might be from ecashin@coraid.com are

aoe-perform-i-o-completions-in-parallel.patch
aoe-update-copyright-date.patch
aoe-update-internal-version-number-to-v83.patch

