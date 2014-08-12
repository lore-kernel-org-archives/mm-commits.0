From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-unused-radeon-drm-pattern.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:43:23 -0700
Message-ID: <53ea6e5b.J60tSrWmEP7IB7p1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f202.google.com ([209.85.213.202]:51970 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016AbaHLTnY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:43:24 -0400
Received: by mail-ig0-f202.google.com with SMTP id r2so1070259igi.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:43:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: remove unused radeon drm pattern
has been removed from the -mm tree.  Its filename was
     maintainers-remove-unused-radeon-drm-pattern.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: remove unused radeon drm pattern

Commit 8dcedd7e87f4 ("UAPI: (Scripted) Disintegrate include/drm") moved
the file, remove the pattern.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

diff -puN MAINTAINERS~maintainers-remove-unused-radeon-drm-pattern MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-unused-radeon-drm-pattern
+++ a/MAINTAINERS
@@ -3039,7 +3039,6 @@ L:	dri-devel@lists.freedesktop.org
 T:	git git://people.freedesktop.org/~agd5f/linux
 S:	Supported
 F:	drivers/gpu/drm/radeon/
-F:	include/drm/radeon*
 F:	include/uapi/drm/radeon*
 
 DRM PANEL DRIVERS
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
mm-utilc-add-kstrimdup.patch
fs-isofs-logging-clean-up.patch
linux-next.patch

