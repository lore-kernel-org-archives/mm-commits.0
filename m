From: akpm@linux-foundation.org
Subject: + kconfig-menu-move-virtualization-drivers-near-other-virtualization-options.patch added to -mm tree
Date: Mon, 18 Mar 2013 14:15:21 -0700
Message-ID: <20130318211521.778935A4005@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f73.google.com ([209.85.219.73]:59341 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab3CRVPW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Mar 2013 17:15:22 -0400
Received: by mail-oa0-f73.google.com with SMTP id o6so1344163oag.2
        for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2013 14:15:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdunlap@infradead.org, agraf@suse.de, stuart.yoder@freescale.com


The patch titled
     Subject: kconfig menu: move Virtualization drivers near other virtualization options
has been added to the -mm tree.  Its filename is
     kconfig-menu-move-virtualization-drivers-near-other-virtualization-options.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: kconfig menu: move Virtualization drivers near other virtualization options

Make virtualization drivers be logically grouped together (physically near
each other) in the kconfig menu by moving "Virtualization drivers" to be
near "Virtio drivers", Microsort Hyper-V, and Xen driver support.

This is just a user-friendly, visual search change.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Alexander Graf <agraf@suse.de>
Cc: Stuart Yoder <stuart.yoder@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/Kconfig~kconfig-menu-move-virtualization-drivers-near-other-virtualization-options drivers/Kconfig
--- a/drivers/Kconfig~kconfig-menu-move-virtualization-drivers-near-other-virtualization-options
+++ a/drivers/Kconfig
@@ -118,6 +118,8 @@ source "drivers/vfio/Kconfig"
 
 source "drivers/vlynq/Kconfig"
 
+source "drivers/virt/Kconfig"
+
 source "drivers/virtio/Kconfig"
 
 source "drivers/hv/Kconfig"
@@ -142,8 +144,6 @@ source "drivers/remoteproc/Kconfig"
 
 source "drivers/rpmsg/Kconfig"
 
-source "drivers/virt/Kconfig"
