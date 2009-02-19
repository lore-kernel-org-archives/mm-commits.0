From: akpm@linux-foundation.org
Subject: [merged] bernhard-has-moved.patch removed from -mm tree
Date: Thu, 19 Feb 2009 11:17:22 -0800
Message-ID: <200902191917.n1JJHMCn016369@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752093AbZBSTR1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:17:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bernhard.walle@gmx.de, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Bernhard has moved
has been removed from the -mm tree.  Its filename was
     bernhard-has-moved.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Bernhard has moved
From: Bernhard Walle <bernhard.walle@gmx.de>

Since I don't work for SUSE any more and the bwalle@suse.de address is
invalid, correct it in the copyright headers and documentation.

Signed-off-by: Bernhard Walle <bernhard.walle@gmx.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-firmware-memmap |    2 +-
 drivers/firmware/memmap.c                       |    2 +-
 include/linux/firmware-map.h                    |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/ABI/testing/sysfs-firmware-memmap~bernhard-has-moved Documentation/ABI/testing/sysfs-firmware-memmap
--- a/Documentation/ABI/testing/sysfs-firmware-memmap~bernhard-has-moved
+++ a/Documentation/ABI/testing/sysfs-firmware-memmap
@@ -1,6 +1,6 @@
 What:		/sys/firmware/memmap/
 Date:		June 2008
-Contact:	Bernhard Walle <bwalle@suse.de>
+Contact:	Bernhard Walle <bernhard.walle@gmx.de>
 Description:
 		On all platforms, the firmware provides a memory map which the
 		kernel reads. The resources from that memory map are registered
diff -puN drivers/firmware/memmap.c~bernhard-has-moved drivers/firmware/memmap.c
--- a/drivers/firmware/memmap.c~bernhard-has-moved
+++ a/drivers/firmware/memmap.c
@@ -1,7 +1,7 @@
 /*
  * linux/drivers/firmware/memmap.c
  *  Copyright (C) 2008 SUSE LINUX Products GmbH
- *  by Bernhard Walle <bwalle@suse.de>
+ *  by Bernhard Walle <bernhard.walle@gmx.de>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License v2.0 as published by
diff -puN include/linux/firmware-map.h~bernhard-has-moved include/linux/firmware-map.h
--- a/include/linux/firmware-map.h~bernhard-has-moved
+++ a/include/linux/firmware-map.h
@@ -1,7 +1,7 @@
 /*
  * include/linux/firmware-map.h:
  *  Copyright (C) 2008 SUSE LINUX Products GmbH
- *  by Bernhard Walle <bwalle@suse.de>
+ *  by Bernhard Walle <bernhard.walle@gmx.de>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License v2.0 as published by
_

Patches currently in -mm which might be from bernhard.walle@gmx.de are

origin.patch

