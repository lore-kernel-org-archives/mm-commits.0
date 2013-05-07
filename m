From: akpm@linux-foundation.org
Subject: [merged] kconfig-menu-move-virtualization-drivers-near-other-virtualization-options.patch removed from -mm tree
Date: Tue, 07 May 2013 10:50:56 -0700
Message-ID: <20130507175056.7EC5931C4F8@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:39011 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759498Ab3EGRu5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:50:57 -0400
Received: by mail-vb0-f73.google.com with SMTP id e13so86417vbg.4
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:50:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, agraf@suse.de, stuart.yoder@freescale.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kconfig menu: move Virtualization drivers near other virtualization options
has been removed from the -mm tree.  Its filename was
     kconfig-menu-move-virtualization-drivers-near-other-virtualization-options.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -120,6 +120,8 @@ source "drivers/vfio/Kconfig"
 
 source "drivers/vlynq/Kconfig"
 
+source "drivers/virt/Kconfig"
+
 source "drivers/virtio/Kconfig"
 
 source "drivers/hv/Kconfig"
@@ -144,8 +146,6 @@ source "drivers/remoteproc/Kconfig"
 
 source "drivers/rpmsg/Kconfig"
 
-source "drivers/virt/Kconfig"
