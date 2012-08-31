From: akpm@linux-foundation.org
Subject: + aoe-update-documentation-with-new-url-and-vm-settings-reference.patch added to -mm tree
Date: Fri, 31 Aug 2012 13:12:16 -0700
Message-ID: <20120831201217.3183A1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:35690 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960Ab2HaUMR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Aug 2012 16:12:17 -0400
Received: by mail-yx0-f202.google.com with SMTP id q6so383761yen.1
        for <mm-commits@vger.kernel.org>; Fri, 31 Aug 2012 13:12:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com


The patch titled
     Subject: aoe: update documentation with new URL and VM settings reference
has been added to the -mm tree.  Its filename is
     aoe-update-documentation-with-new-url-and-vm-settings-reference.patch

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
Subject: aoe: update documentation with new URL and VM settings reference

The old area has a new URL.  Also, now that the driver can perform better,
it is worth mentioning the VM settings that help aoe to sink dirty pages
out early, avoiding unecessary memory pressure when much I/O is going on.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/aoe/aoe.txt |    9 ++++++---
 MAINTAINERS               |    2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff -puN Documentation/aoe/aoe.txt~aoe-update-documentation-with-new-url-and-vm-settings-reference Documentation/aoe/aoe.txt
--- a/Documentation/aoe/aoe.txt~aoe-update-documentation-with-new-url-and-vm-settings-reference
+++ a/Documentation/aoe/aoe.txt
@@ -1,8 +1,11 @@
-The EtherDrive (R) HOWTO for users of 2.6 kernels is found at ...
+The EtherDrive (R) HOWTO for 2.6 and 3.x kernels is found at ...
 
-  http://www.coraid.com/SUPPORT/EtherDrive-HBA  
+  http://support.coraid.com/support/linux/EtherDrive-2.6-HOWTO.html
 
-  It has many tips and hints!
+It has many tips and hints!  Please see, especially, recommended
+tunings for virtual memory:
+
+  http://support.coraid.com/support/linux/EtherDrive-2.6-HOWTO-5.html#ss5.19
 
 The aoetools are userland programs that are designed to work with this
 driver.  The aoetools are on sourceforge.
diff -puN MAINTAINERS~aoe-update-documentation-with-new-url-and-vm-settings-reference MAINTAINERS
--- a/MAINTAINERS~aoe-update-documentation-with-new-url-and-vm-settings-reference
+++ a/MAINTAINERS
@@ -1250,7 +1250,7 @@ F:	include/linux/i2c/at24.h
 
 ATA OVER ETHERNET (AOE) DRIVER
 M:	"Ed L. Cashin" <ecashin@coraid.com>
-W:	http://www.coraid.com/support/linux
+W:	http://support.coraid.com/support/linux
 S:	Supported
 F:	Documentation/aoe/
 F:	drivers/block/aoe/
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

