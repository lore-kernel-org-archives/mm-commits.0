From: akpm@linux-foundation.org
Subject: [merged] maintainers-remove-include-asm-suspend-file-patterns.patch removed from -mm tree
Date: Wed, 22 Apr 2009 11:30:23 -0700
Message-ID: <200904221830.n3MIUNgw006172@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753140AbZDVSce (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Apr 2009 14:32:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: remove include/asm-*/suspend* file patterns
has been removed from the -mm tree.  Its filename was
     maintainers-remove-include-asm-suspend-file-patterns.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: remove include/asm-*/suspend* file patterns
From: Joe Perches <joe@perches.com>

There are no more arches with suspend support using these directories.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 --
 1 file changed, 2 deletions(-)

diff -puN MAINTAINERS~maintainers-remove-include-asm-suspend-file-patterns MAINTAINERS
--- a/MAINTAINERS~maintainers-remove-include-asm-suspend-file-patterns
+++ a/MAINTAINERS
@@ -2562,7 +2562,6 @@ F:	kernel/power/
 F:	include/linux/suspend.h
 F:	include/linux/freezer.h
 F:	include/linux/pm.h
-F:	include/asm-*/suspend*.h
 F:	arch/*/include/asm/suspend*.h
 
 HID CORE LAYER
@@ -5404,7 +5403,6 @@ F:	kernel/power/
 F:	include/linux/suspend.h
 F:	include/linux/freezer.h
 F:	include/linux/pm.h
-F:	include/asm-*/suspend.h
 
 SVGA HANDLING
 P:	Martin Mares
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch

