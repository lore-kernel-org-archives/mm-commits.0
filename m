From: akpm@linux-foundation.org
Subject: [merged] maintainers-staging-media-update-f-patterns.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:29:29 -0800
Message-ID: <20120111212929.A02ED10004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:48989 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121Ab2AKV3a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:29:30 -0500
Received: by mail-gx0-f202.google.com with SMTP id k3so134376ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:29:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, greg@kroah.com, mchehab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: staging: media: update F: patterns
has been removed from the -mm tree.  Its filename was
     maintainers-staging-media-update-f-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: staging: media: update F: patterns

commit 4860c73804c ("staging: Move media drivers to staging/media") moved
the files, update the F: patterns.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Mauro Carvalho Chehab<mchehab@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-staging-media-update-f-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-staging-media-update-f-patterns
+++ a/MAINTAINERS
@@ -6300,7 +6300,7 @@ STAGING - LIRC (LINUX INFRARED REMOTE CO
 M:	Jarod Wilson <jarod@wilsonet.com>
 W:	http://www.lirc.org/
 S:	Odd Fixes
-F:	drivers/staging/lirc/
+F:	drivers/staging/media/lirc/
 
 STAGING - NVIDIA COMPLIANT EMBEDDED CONTROLLER INTERFACE (nvec)
 M:	Julian Andres Klode <jak@jak-linux.org>
@@ -6336,7 +6336,7 @@ F:	drivers/staging/sm7xx/
 STAGING - SOFTLOGIC 6x10 MPEG CODEC
 M:	Ben Collins <bcollins@bluecherry.net>
 S:	Odd Fixes
-F:	drivers/staging/solo6x10/
+F:	drivers/staging/media/solo6x10/
 
 STAGING - SPEAKUP CONSOLE SPEECH DRIVER
 M:	William Hubbs <w.d.hubbs@gmail.com>
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-staging-cx25821-add-l-linux-media.patch
kernelh-neaten-panic-prototype.patch
linkage-remove-unused-noret_and-macro.patch
treewide-remove-useless-noret_type-macro-and-uses.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn.patch
treewide-convert-uses-of-attrib_noreturn-to-__noreturn-checkpatch-fixes.patch
linkage-remove-unused-attrib_noret-macro.patch

