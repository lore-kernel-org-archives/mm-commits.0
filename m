From: akpm@linux-foundation.org
Subject: + aoe-remove-unused-code.patch added to -mm tree
Date: Tue, 02 Oct 2012 14:18:18 -0700
Message-ID: <20121002211819.2510D1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:47264 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280Ab2JBVSU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Oct 2012 17:18:20 -0400
Received: by qaea16 with SMTP id a16so152918qae.1
        for <mm-commits@vger.kernel.org>; Tue, 02 Oct 2012 14:18:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com


The patch titled
     Subject: aoe: remove unused code
has been added to the -mm tree.  Its filename is
     aoe-remove-unused-code.patch

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
Subject: aoe: remove unused code

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/aoe/aoe.h |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/block/aoe/aoe.h~aoe-remove-unused-code drivers/block/aoe/aoe.h
--- a/drivers/block/aoe/aoe.h~aoe-remove-unused-code
+++ a/drivers/block/aoe/aoe.h
@@ -10,9 +10,6 @@
 #define AOE_PARTITIONS (16)
 #endif
 
-#define SYSMINOR(aoemajor, aoeminor) ((aoemajor) * NPERSHELF + (aoeminor))
-#define AOEMAJOR(sysminor) ((sysminor) / NPERSHELF)
-#define AOEMINOR(sysminor) ((sysminor) % NPERSHELF)
 #define WHITESPACE " \t\v\f\n"
 
 enum {
@@ -82,7 +79,6 @@ enum {
 
 enum {
 	DEFAULTBCNT = 2 * 512,	/* 2 sectors */
-	NPERSHELF = 16,		/* number of slots per shelf address */
 	MIN_BUFS = 16,
 	NTARGETS = 8,
 	NAOEIFS = 8,
_

Patches currently in -mm which might be from ecashin@coraid.com are

aoe-for-performance-support-larger-packet-payloads.patch
aoe-kernel-thread-handles-i-o-completions-for-simple-locking.patch
aoe-kernel-thread-handles-i-o-completions-for-simple-locking-fix.patch
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
aoe-support-more-aoe-addresses-with-dynamic-block-device-minor-numbers.patch
aoe-retain-static-block-device-numbers-for-backwards-compatibility.patch
aoe-update-and-specify-aoe-address-guards-and-error-messages.patch
aoe-make-dynamic-block-minor-numbers-the-default.patch
aoe-remove-unused-code.patch
aoe-update-documentation-to-better-reflect-aoe-plus-udev-usage.patch
aoe-update-aoe-internal-version-number-to-50.patch

