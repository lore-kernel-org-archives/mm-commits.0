From: akpm@linux-foundation.org
Subject: + bernhard-has-moved.patch added to -mm tree
Date: Tue, 17 Feb 2009 13:30:12 -0800
Message-ID: <200902172130.n1HLUCtS020413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59822 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750988AbZBQVbK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Feb 2009 16:31:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bernhard.walle@gmx.de, greg@kroah.com


The patch titled
     Bernhard has moved
has been added to the -mm tree.  Its filename is
     bernhard-has-moved.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

bernhard-has-moved.patch

