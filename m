From: akpm@linux-foundation.org
Subject: - ide-add-optical-to-sysfs-media-attribute.patch removed from -mm tree
Date: Fri, 06 Apr 2007 13:08:54 -0700
Message-ID: <200704062008.l36K8se2017880@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:32795 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932785AbXDFUI5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 16:08:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dkukawka@suse.de, mm-commits@vger.kernel.org


The patch titled
     ide: add "optical" to sysfs "media" attribute
has been removed from the -mm tree.  Its filename was
     ide-add-optical-to-sysfs-media-attribute.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
