From: akpm@linux-foundation.org
Subject: + ide-add-optical-to-sysfs-media-attribute.patch added to -mm tree
Date: Tue, 03 Apr 2007 16:34:05 -0700
Message-ID: <200704032334.l33NY5Tq006516@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48587 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933094AbXDCXeN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 3 Apr 2007 19:34:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dkukawka@suse.de


The patch titled
     ide: add "optical" to sysfs "media" attribute
has been added to the -mm tree.  Its filename is
     ide-add-optical-to-sysfs-media-attribute.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ide: add "optical" to sysfs "media" attribute
From: Danny Kukawka <dkukawka@suse.de>

Add "optical" to sysfs "media" attribute as already in /proc

Signed-off-by: Danny Kukawka <dkukawka@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/ide.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/ide/ide.c~ide-add-optical-to-sysfs-media-attribute drivers/ide/ide.c
--- a/drivers/ide/ide.c~ide-add-optical-to-sysfs-media-attribute
+++ a/drivers/ide/ide.c
@@ -1682,6 +1682,8 @@ static char *media_string(ide_drive_t *d
 		return "tape";
 	case ide_floppy:
 		return "floppy";
+	case ide_optical:
+		return "optical";
 	default:
 		return "UNKNOWN";
 	}
_

Patches currently in -mm which might be from dkukawka@suse.de are

ide-add-optical-to-sysfs-media-attribute.patch
