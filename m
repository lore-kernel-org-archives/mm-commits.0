From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-new-entry-for-ideapad-laptop.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:14:35 -0700
Message-ID: <201111012114.pA1LEZEs006989@hpaq11.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:16364 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1KAVOk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:14:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ike.pan@canonical.com, mjg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add new entry for ideapad-laptop
has been removed from the -mm tree.  Its filename was
     maintainers-add-new-entry-for-ideapad-laptop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Ike Panhc <ike.pan@canonical.com>
Subject: MAINTAINERS: add new entry for ideapad-laptop

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN MAINTAINERS~maintainers-add-new-entry-for-ideapad-laptop MAINTAINERS
--- a/MAINTAINERS~maintainers-add-new-entry-for-ideapad-laptop
+++ a/MAINTAINERS
@@ -3209,6 +3209,13 @@ F:	Documentation/ide/
 F:	drivers/ide/
 F:	include/linux/ide.h
 
+IDEAPAD LAPTOP EXTRAS DRIVER
+M:	Ike Panhc <ike.pan@canonical.com>
+L:	platform-driver-x86@vger.kernel.org
+W:	http://launchpad.net/ideapad-laptop
+S:	Maintained
+F:	drivers/platform/x86/ideapad-laptop.c
+
 IDE/ATAPI DRIVERS
 M:	Borislav Petkov <petkovbb@gmail.com>
 L:	linux-ide@vger.kernel.org
_

Patches currently in -mm which might be from ike.pan@canonical.com are

origin.patch

