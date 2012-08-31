From: akpm@linux-foundation.org
Subject: + aoe-update-internal-version-number-to-49.patch added to -mm tree
Date: Fri, 31 Aug 2012 13:12:10 -0700
Message-ID: <20120831201211.8F434200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:50683 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab2HaUMN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Aug 2012 16:12:13 -0400
Received: by mail-fa0-f74.google.com with SMTP id s10so171629fas.1
        for <mm-commits@vger.kernel.org>; Fri, 31 Aug 2012 13:12:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com


The patch titled
     Subject: aoe: update internal version number to 49
has been added to the -mm tree.  Its filename is
     aoe-update-internal-version-number-to-49.patch

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
Subject: aoe: update internal version number to 49

The internal version number of the aoe driver appears in a console message
when the driver loads and is usually obtained by the user with the
userland aoe-version tool, part of the aoetools.[1]

Although this patchset includes bugfixes backported from higher-numbered
versions published on the coraid.com website, it is a form of version 49.

1. http://aoetools.sourceforge.net/

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/aoe/aoe.h~aoe-update-internal-version-number-to-49 drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-update-internal-version-number-to-49
+++ a/drivers/block/aoe/aoe.h
@@ -1,5 +1,5 @@
 /* Copyright (c) 2007 Coraid, Inc.  See COPYING for GPL terms. */
-#define VERSION "47"
+#define VERSION "49"
 #define AOE_MAJOR 152
 #define DEVICE_NAME "aoe"
 
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

